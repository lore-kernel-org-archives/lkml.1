Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbZFQLbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbZFQLbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 07:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZFQLb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 07:31:26 -0400
Received: from mail-qy0-f201.google.com ([209.85.221.201]:64867 "EHLO
	mail-qy0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbZFQLbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 07:31:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BFnIo4wiRxGFjsplXxB+lsud06lxBRc/GH0TTM6qjy8L5F8MpTKP6rQh4pv1z+M9WV
         mBy0Z/YyuApQmriJfs7/vq5GuNuagn2yy+xfdXo2RJ2lIo8eHnEHNKnH9i4aSGnV905K
         H7q6KA4+Hr+bv+j8mdWeNnakno+OOAF4ah2gA=
MIME-Version: 1.0
In-Reply-To: <8628FE4E7912BF47A96AE7DD7BAC0AADCB2592D730@SJEXCHCCR02.corp.ad.broadcom.com>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADCB2592D730@SJEXCHCCR02.corp.ad.broadcom.com>
Date: Wed, 17 Jun 2009 17:01:22 +0530
Message-ID: <5d5443650906170431o74156ed0o8f45a8702faf8b65@mail.gmail.com>
Subject: Re: QUESTION: new arch/arm/mach-bcmring code submission
From: Trilok Soni <soni.trilok@gmail.com>
To: "Leo (Hao) Chen" <leochen@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm@lists.arm.linux.org.uk" <linux-arm@lists.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leo,

On Wed, Jun 17, 2009 at 1:14 AM, Leo (Hao) Chen <leochen@broadcom.com> wrote:
> Hi,
>
> Our team in Broadcom plan to submit our code of a new ARM11 SoC support to kernel.org.
> As we have no experience in doing this, I hope that we can get some more information regarding the code submission.
>
> 1. We have a whole lot of OS-less csp (chip support package) code that is used in our drivers and arch code. We will release them as GPL but we want to keep and maintain them in our own csp directories.  Can we put them under arch/arm/mach-bcmring/csp and arch/arm/mach-bcmring/include/csp directories?  If not, what's the proper way to do that?

As Alan mentioned, it is difficult to comment without seeing it.
Please also subscribe :) to arm-linux-kernel mailing list so you could
have interaction with arm-linux-kernel community. But you can always
CC linux-kernel :).

>
> 2. We have driver header files which are currently kept in the include/linux/broadcom directory.  Where is the proper place to put our driver header files in Linux kernel?  Any guidelines?
>
> 3. Do I need to submit our code to any maintainer or just submit to LKML?

ARM-Linux kernel maintainer is Russell King. Please post your patches
to linux-arm-kernel mailing list and CC LKML. You should first target
mainlining your "mach-bcmring" core code, which should atleast be able
to get your serial console and minimal filesystem. Other additional
drivers can be submitted once core code gets in.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
