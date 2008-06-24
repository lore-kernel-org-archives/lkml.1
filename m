Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYFXHaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYFXHaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 03:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYFXHaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 03:30:01 -0400
Received: from main.gmane.org ([80.91.229.2]:38858 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbYFXHaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 03:30:00 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu CASTET <matthieu.castet@parrot.com>
Subject: Re: [PATCH 1/3] build system: section garbage collection - rename sections
Date: Tue, 24 Jun 2008 07:29:50 +0000 (UTC)
Message-ID: <loom.20080624T072614-586@post.gmane.org>
References: <200709112105.34301.vda.linux@googlemail.com> <20071118230057.GA6303@uranus.ravnborg.org> <200711241514.26451.vda.linux@googlemail.com> <200711241517.00164.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 62.210.107.40 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9) Gecko/2008062113 Iceweasel/3.0 (Debian-3.0~rc2-1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Denys Vlasenko <vda.linux <at> googlemail.com> writes:

> 
> On Saturday 24 November 2007 15:14, Denys Vlasenko wrote:
> > 1.fixname:
> >     Rename all special sections with names like .text.xxxx, .data.xxxx and
> >     .rodata.xxxx to .xxxx.text/data/rodata. This makes it possible to
> >     not mix up these sections with gcc-generated ones
> >     when gcc -ffunction-sections -fdata-sections is used.
> >     .bss.xxxx cannot be treated this way, because for section names
> >     linke .xxxx.bss gcc won't create section with correct attribute.
> >     Thus .bss.xxxxx sections are renamed .bss.k.xxxxx.
> 
> Signed-off-by: Denys Vlasenko <vda.linux <at> googlemail.com>
Why not rename all the section to .type.k.xxxxx ?
This will be more consistent between bss and other section. Also I find it
cleaner to have the section type first.

Matthieu 


