Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZKDLEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZKDLEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbZKDLEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:04:08 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:44299 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbZKDLEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:04:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=qBsbPrOb+PU2iq/3I8GFPP7bBADL3liZzT3E8wp6ofilvMdYUAeGWy7+OnK/uDrr2X
         eSfRj2EqG8/EjEMrbGNhMtczMbHFDev/ikYcs15NMrcGgBHA9C18BaTq/HFye3dFrhnL
         qGjlcauvC+d1/TmNkNN+0uFvmzZJquP/+O4iE=
Subject: Re: [PATCH -queue v0 1/6] [loongson] add basic loongson-2f support
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Arnaud Patard <apatard@mandriva.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, huhb@lemote.com, yanh@lemote.com,
       Zhang Le <r0bertz@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
In-Reply-To: <m3iqdqtwgk.fsf@anduin.mandriva.com>
References: <cover.1257325319.git.wuzhangjin@gmail.com>
	 <a1bd2470bc465e505281c761adca8c2287d102b3.1257325319.git.wuzhangjin@gmail.com>
	 <m3iqdqtwgk.fsf@anduin.mandriva.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Wed, 04 Nov 2009 19:04:12 +0800
Message-ID: <1257332652.8716.5.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-11-04 at 11:28 +0100, Arnaud Patard wrote:
[...]
> > +
> > +config CPU_LOONGSON2F
> > +	bool "Loongson 2F"
> > +	depends on SYS_HAS_CPU_LOONGSON2F
> > +	select CPU_LOONGSON2
> > +	help
> > +	  The Loongson 2F processor implements the MIPS III instruction set
> > +	  with many extensions.
> > +
> > +	  Loongson2F have built-in DDR2 and PCIX controller. The PCIX controller
> > +	  have a similar programming interface with FPGA northbridge used in
> > +	  Loongson2E.
> > +
> 
> Small question : Why don't you restrict to 64bit kernels only ? From
> what I remember from some discussions with ST, trying to use a 32-bit
> kernel on 2f is a nice way to get troubles. It would be better imho to
> forbid such a configuration. As a side effect, this will remove all
> 'defined(CONFIG_64BIT)' parts of your #ifdef tests. 
> 

It's hard to make such a decision ;) Perhaps some guys want to play with
the 32bit version.

Regards,
	Wu Zhangjin

