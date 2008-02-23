Return-Path: <linux-kernel-owner+w=401wt.eu-S1761494AbYBWIAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494AbYBWIAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYBWIAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:00:19 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46312 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbYBWIAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:00:18 -0500
Date: Sat, 23 Feb 2008 09:00:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-git-current several Section mismatch in reference from ...
Message-ID: <20080223080029.GA11684@uranus.ravnborg.org>
References: <1203752993.4498.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1203752993.4498.4.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 08:49:53AM +0100, Soeren Sonnenburg wrote:
> compiling with
> 
> make CONFIG_DEBUG_SECTION_MISMATCH=y
> 
> I see the following warnings:
> 
>   CC      kernel/stacktrace.o
>   CC      kernel/irq/handle.o
>   LD      mm/built-in.o


Hi Sören.

>From a quick scan I would say most if not all of the
section mismatch warnings are dealt with. The patches
are queued for next -mm and some may be forwarded to
mainline before the release.

Patchset was posted by me last weeken to lkml so they
should be fairly easy to find.

	Sam
