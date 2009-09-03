Return-Path: <linux-kernel-owner+w=401wt.eu-S932297AbZICUve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbZICUve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbZICUve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:51:34 -0400
Received: from claw.goop.org ([74.207.240.146]:51582 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247AbZICUvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:51:33 -0400
Message-ID: <4AA02C57.30106@goop.org>
Date: Thu, 03 Sep 2009 13:51:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Bastian Blank <waldi@debian.org>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, 544145@bugs.debian.org,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: 32bit binaries on x86_64/Xen segfaults in syscall-vdso
References: <20090830181637.GA7155@wavehammer.waldi.eu.org>
In-Reply-To: <20090830181637.GA7155@wavehammer.waldi.eu.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/09 11:16, Bastian Blank wrote:
> Hi folks
>
> I upgraded one of my 32bit chroots on a x86-64 machine runing under Xen
> lately. All binaries started to segfault. Some extensive checks later
> show the vdso as the culprit. Later I found <gpe0vg$j67$1@ger.gmane.org>
> with the same problem. The full story can be found in the Debian bug
> 544145[1].
>
> It happens with Linux 2.6.30 and 2.6.31-rc8 on Xen 3.2 and 3.4.
>
> For the tests I set the vdso to compat mode to have it loaded on a fixed
> location.
>
> The following program is a minimal test case for the vdso in compat
> mode, it can be compiled against dietlibc to minimize other effects.
>   

Is this an AMD machine?  Does booting with vdso32=0 on the kernel
command line work around the problem?

     J
