Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbYIGDQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbYIGDQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 23:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbYIGDQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 23:16:04 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:44569 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbYIGDQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 23:16:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sZHCtCBa9Uqi/uTpZ09Lzx3TN9q5OU3oh+jWFtNYNoI2lGK7WKMVsIY7+XbSs6e9j4
         9NZ0NiGDLa+ztneZD6cFGpR9x0F3HjLG356h85xVg77C1hJqr46n9QR1k8Ofs/9d39IJ
         7zvCa2ovRBS/3f6NmaP9dKP/32szLwrtl+4mA=
Message-ID: <8ee0b8e80809062016r12388b59nea95f820079c39f8@mail.gmail.com>
Date: Sun, 7 Sep 2008 05:16:00 +0200
From: "Jeroen van Rijn" <jvrnix@gmail.com>
To: "Tony Vroon" <tony@vroon.org>
Subject: Re: Request for MCE decode (AMD Barcelona, fam 10h)
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1220754742.8530.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220754742.8530.12.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 7, 2008 at 4:32 AM, Tony Vroon <tony@vroon.org> wrote:
> On a Tyan-based system with intermittent but persistent instability, I
> have finally received a message that something might actually be wrong
> in hardware. Could you decode:
>
> MCE 0
> HARDWARE ERROR. This is *NOT* a software problem!
> Please contact your hardware vendor
> CPU 0 BANK 4 MISC c000000001000000
> STATUS fa00002000020c0f MCGSTATUS 0
> MCE 1
> HARDWARE ERROR. This is *NOT* a software problem!
> Please contact your hardware vendor
> CPU 4 BANK 4 MISC c000000001000000
> STATUS fa00000000070f0f MCGSTATUS 0

Hi Tony,

Not easily, and it's too late to parse
arch/x86/kernel/cpu/mcheck/mce_64.c and find out what it means before
I nod off. Still, before I sign off, have you tried running "mcelog
--ascii"? It needs to be run on the machine the check occured on. It
might give you something to go on before the cavalry arrives.

Best regards,
  Jeroen.
