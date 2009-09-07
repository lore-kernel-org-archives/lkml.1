Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbZIGOgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbZIGOgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 10:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZIGOgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 10:36:19 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:50948 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbZIGOgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 10:36:19 -0400
Date: Mon, 7 Sep 2009 10:35:59 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Hirokazu Takata <takata@linux-m32r.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 5/6] m32r: Move the spi_stack_top and spu_stack_top into
 .data section.
In-Reply-To: <swfzl97hr8g.wl%takata.hirokazu@renesas.com>
Message-ID: <alpine.DEB.1.10.0909071022080.17860@dr-wily.mit.edu>
References: <1252293179-13382-1-git-send-email-tabbott@ksplice.com> <1252293179-13382-5-git-send-email-tabbott@ksplice.com> <swfzl97hr8g.wl%takata.hirokazu@renesas.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Hirokazu Takata wrote:

> From: Tim Abbott <tabbott@ksplice.com>
> Subject: [PATCH 5/6] m32r: Move the spi_stack_top and spu_stack_top into .data section.
> Date: Sun, 06 Sep 2009 23:12:58 -0400
> > Since these get squashed into the .data output section by the m32r
> > linker script, it seems likely that they don't need their own input
> > sections.
> > 
> > I'd like an explicit confirmation from Hirokazu Takata that this is
> > correct (in particular, that there isn't some hidden reason why there
> > two structures need to be at the start of the .data output section).
> 
> There is no apparent reason.  We've placed them at the start of .data
> section, because they are for initial stack region.
> 
> I think it would be better that we place them to .init.data section.
> Any comment?

Assuming that they aren't used after the initial boot process, that's 
probably the right choice.

	-Tim Abbott
