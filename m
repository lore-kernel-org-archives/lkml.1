Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZGXP3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZGXP3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZGXP3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:29:42 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:63000 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbZGXP3l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:29:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=JfpeL9u3dEh3i+VQHUULi2zr1UgcfgnrZ8Kr9fW9vbGd1p45y7ZZ26PVhby8Dde/Vo
         ilu2Lf72Dyj5ABo+XD3Ahb76xPATusB5ftYWMrRV5+iYtm6ICKPy0DZNykou+ul+7ZKP
         5zfdJGtUOL7JjX2EyvVSb/756GqEfMTm3DzB0=
MIME-Version: 1.0
In-Reply-To: <200907241700.24170.diegocg@gmail.com>
References: <194f62550907240636o5ba623cdy1f16deb7f6d70eeb@mail.gmail.com>
	 <200907241700.24170.diegocg@gmail.com>
Date: Fri, 24 Jul 2009 11:29:40 -0400
Message-ID: <194f62550907240829m1834bc26r8e23baba4b295ae4@mail.gmail.com>
Subject: Re: Status of ext4 online defrag?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Does anybody know what the current state of ext4 online defrag is?
>
> It got merged for 2.6.31 (commit 748de6736c1e482e111f9d1b5a5d5b1787600cad)

Thanks, how cool!
I feared already that this feature is dead, glad to hear it is not :)

When compiling e2fsprogs from git, I get:
> e4defrag.c:388: error: conflicting types for ‘fallocate’
> /usr/include/bits/fcntl.h:240: note: previous declaration of ‘fallocate’ was here
> make: *** [e4defrag.o] Error 1

I had to comment out fallocate in fcntl.h, no idea who is wrong here.

Thanks again, Clemens
