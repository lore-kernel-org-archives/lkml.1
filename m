Return-Path: <linux-kernel-owner+w=401wt.eu-S1758958AbXEMMbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbXEMMbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 08:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbXEMMbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 08:31:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:62729 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508AbXEMMbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 08:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zb6OfPU3smXuB5oeVS+hkIt2gpH2/WE8vCkLKZc2Uf7tLf9ciZxemJluoBxA11aE73EolLGHcgk1HaVo121lv6kt7xw4wFutEVvR01CQHkqT+iBAIf8p8j/dSHkUe2tLbx4wbVOUt23JguDhJeY/XADP9pVAv78xRtojjZcTK7Q=
Message-ID: <5a4c581d0705130531v4679efabgd2ffed96af72862d@mail.gmail.com>
Date: Sun, 13 May 2007 14:31:22 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "umesh@websurfer.com.np" <umesh@websurfer.com.np>
Subject: Re: upgrade linux kernel
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2417.63.219.2.2.1179056431.squirrel@mail.websurfer.com.np>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2417.63.219.2.2.1179056431.squirrel@mail.websurfer.com.np>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/13/07, umesh@websurfer.com.np <umesh@websurfer.com.np> wrote:
> I am upgrading kernel from 2.4.20-8(default in RH9) to 2.6.xx. when I do
> "make" command it gives some output and finally get error saying that,
>
> "BFD: Warning: Writing section '.bss' to huge ( ie negative) file offset
> 0xc0244000. "
>
>  "Objcopy: arch/i386/boot/compressed/vmlinux.bin: file truncated"
>
> "make[2]:***[ arch/i386/boot/compressed/vmlinux.bin] Error 1"
>
>  "make[1]: ***[ arch/i386/boot/compressed/vmlinux] Error 2"
>
>  "make: *** [bzImage] Error 2"

A quick round of googling brings up this

http://www.uwsg.iu.edu/hypermail/linux/kernel/0410.3/0205.html

 where the issue was that binutils were too old to compile the
 newer kernels. More generically, RH9 is now really ancient,
 and you'd probably make your life much easier by upgrading
 to more recent distributions.

If you intend to stay on RH9, please have a look at the
 /usr/src/linux/Documentation/Changes file, it will give you
 a first idea of how much stuff you need to upgrade on RH9.

--alessandro

 "Did you get married but forgot to get divorced ?"

     (Danny and Dusty, 'The Good Old Days')
