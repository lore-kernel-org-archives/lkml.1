Return-Path: <linux-kernel-owner+w=401wt.eu-S932674AbXILUxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbXILUxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 16:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759594AbXILUxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 16:53:09 -0400
Received: from homer.mvista.com ([63.81.120.158]:51350 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757310AbXILUxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 16:53:09 -0400
Subject: Re: [PATCH 1/4] build system: section garbage collection for
	vmlinux
From: Daniel Walker <dwalker@mvista.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200709122118.31890.vda.linux@googlemail.com>
References: <200709112105.34301.vda.linux@googlemail.com>
	 <200709112107.53155.vda.linux@googlemail.com>
	 <1189547259.20371.19.camel@imap.mvista.com>
	 <200709122118.31890.vda.linux@googlemail.com>
Content-Type: text/plain
Date: Wed, 12 Sep 2007 13:52:33 -0700
Message-Id: <1189630353.20371.28.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-12 at 21:18 +0100, Denys Vlasenko wrote:
> On Tuesday 11 September 2007 22:47, Daniel Walker wrote:
> > On Tue, 2007-09-11 at 21:07 +0100, Denys Vlasenko wrote:
> > > This patch is needed for --gc-sections to work, regardless
> > > of which final form that support will have.
> > > 
> > > This patch renames .text.xxx and .data.xxx sections
> > > into .xxx.text and .xxx.data, respectively.
> > 
> > I think you'll have better luck with this if you focus on a single
> > architecture (i386 would be best) .. 
> 
> I did exactly that. I focused on x86_64.
> 
> Of course, section name fixes cannot be done per-arch, as they
> are scattered across entire tree.

This is want I'm talking about .. Why can't you do this per
architecture?

Daniel

