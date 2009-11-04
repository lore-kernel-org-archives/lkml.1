Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbZKDPXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbZKDPXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZKDPXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:23:44 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:42796 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040AbZKDPXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:23:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=NqOSNuxSMdZbf2gusNnmuDT0GMnoyrNV3EvMWchzzwJdLpicGVP18r5H0/CIbp8eJU
         scwY6fTaqoiQag+jEsk4IzqkcrR+eku0zOyarcz3viY9GWg0IEIP25pa5DfcHJf8/qGD
         NmTD3kc4TNdf/XFFgV9+OfEl4UrrFSaJ5aviA=
Subject: Re: [PATCH -queue v0 1/6] [loongson] add basic loongson-2f support
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Arnaud Patard <apatard@mandriva.com>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, huhb@lemote.com, yanh@lemote.com,
       Zhang Le <r0bertz@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
In-Reply-To: <20091104111957.GA13549@linux-mips.org>
References: <cover.1257325319.git.wuzhangjin@gmail.com>
	 <a1bd2470bc465e505281c761adca8c2287d102b3.1257325319.git.wuzhangjin@gmail.com>
	 <m3iqdqtwgk.fsf@anduin.mandriva.com>
	 <1257332652.8716.5.camel@falcon.domain.org>
	 <20091104111957.GA13549@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Wed, 04 Nov 2009 23:23:46 +0800
Message-ID: <1257348226.16033.4.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-11-04 at 12:19 +0100, Ralf Baechle wrote:
> On Wed, Nov 04, 2009 at 07:04:12PM +0800, Wu Zhangjin wrote:
> 
> > > Small question : Why don't you restrict to 64bit kernels only ? From
> > > what I remember from some discussions with ST, trying to use a 32-bit
> > > kernel on 2f is a nice way to get troubles. It would be better imho to
> > > forbid such a configuration. As a side effect, this will remove all
> > > 'defined(CONFIG_64BIT)' parts of your #ifdef tests. 
> > > 
> > 
> > It's hard to make such a decision ;) Perhaps some guys want to play with
> > the 32bit version.
> 
> We have other systems where 32-bit kernel support is just remarkably ugly.
> We've dropped 32-bit support for the SGI IP32 aka O2 - nobody seems to even
> have really noticed that.  The Sibyte systems would be good candidates to do
> the same as accesses to outside the 32-bit address space are needed very
> frequently.
> 

So, we really remove the 32bit support?

1312 config CPU_LOONGSON2
1313         bool
1314         select CPU_SUPPORTS_32BIT_KERNEL  --> remove it?
1315         select CPU_SUPPORTS_64BIT_KERNEL
1316         select CPU_SUPPORTS_HIGHMEM

If you all agree, I will send a new patch to remove the above line and
resend the corresponding patches without 32bit support, and removed the
relative CONFIG_64BIT lines in the patches too.

Regards,
	Wu Zhangjin

