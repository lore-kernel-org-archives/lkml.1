Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbYL2QW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbYL2QW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYL2QWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:22:20 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:59604 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYL2QWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:22:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iyKNi6wUtgsiKaqQXCoUN5wnpp0o5Qkn+XOPFmr+LxBxy1lHHaiYZQfMrt46ZIrgI5
         CxGLKGcRuGOQi/5RyWwyfmiGnChI/yDrdrQnSbhXjCM5QYYEfnH6qsMlLZBvoY5DL3cv
         bCLOekF3+b+fw9CzSHSdTDBKJtz9fY1LnKmuQ=
Message-ID: <2f11576a0812290822t25b26addu9ab7c04001c1ec7a@mail.gmail.com>
Date: Tue, 30 Dec 2008 01:22:18 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@gmail.com>
To: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <20081229160538.GA5952@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu>
	 <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com>
	 <20081227173839.GA9793@elte.hu>
	 <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain>
	 <20081228232729.GA2158@elte.hu> <20081228233028.GA14697@elte.hu>
	 <20081229110012.GB11111@linux.vnet.ibm.com>
	 <20081229110533.GA29592@elte.hu>
	 <20081229160538.GA5952@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >     kernel crashes after applying the patch, I will retest with
>> > the patch posted at http://lkml.org/lkml/2008/12/29/48
>>
>> yes - Yinghai observed this too. Could you check tip/master that has all
>> the fixlets merged up, to make sure it's finally solved? Thanks,
>>
>> also, what is the gcc -v output of your compiler?
>>
>>       Ingo
>
> Hi Ingo/Yinghai,
>
>        Thanks for getting it resolved, the latest tip/master boot's up fine :)
>
> $ gcc -v
> Using built-in specs.
> Target: x86_64-redhat-linux
> Configured with: ../configure --prefix=/usr
> --mandir=/usr/share/man
> --infodir=/usr/share/info
> --enable-shared
> --enable-threads=posix
> --enable-checking=release
> --with-system-zlib
> --enable-__cxa_atexit
> --disable-libunwind-exceptions
> --enable-libgcj-multifile
> --enable-languages=c,c++,objc,obj-c++,java,fortran,ada
> --enable-java-awt=gtk
> --disable-dssi
> --with-java-home=/usr/lib/jvm/java-1.4.2-gcj-1.4.2.0/jre
> --with-cpu=generic
> --host=x86_64-redhat-linux
> Thread model: posix
> gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)

note, my following compiler doesn't have this problem.

% LANG=C gcc -v
Using built-in specs.
Target: i386-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
--infodir=/usr/share/info --enable-shared --enable-threads=po\
six --enable-checking=release --with-system-zlib --enable-__cxa_atexit
--disable-libunwind-exceptions --enable-libgcj-multifile -\
-enable-languages=c,c++,objc,obj-c++,java,fortran,ada
--enable-java-awt=gtk --disable-dssi --enable-plugin
--with-java-home=/usr/\
lib/jvm/java-1.4.2-gcj-1.4.2.0/jre --with-cpu=generic --host=i386-redhat-linux
Thread model: posix
gcc version 4.1.2 20070626 (Red Hat 4.1.2-14)
