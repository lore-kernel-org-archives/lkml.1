Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbZALLwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbZALLwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbZALLwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:52:09 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:13501 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZALLwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:52:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uQqcUDK1BxZfOew8tvup11dlVUlpC/eDeHmUFn+eo/8Zp708rc/gu7xfaTKPcyvsKd
         gTvxIDvPhbNXgIm+5J0dHfSn3QshAMewrAg1KtDeXDwauHvYFd9w0i5I0a8dOFKmPWKc
         Os23lKmQBtqJ8Sy6Go06XXIVIbHMDfHvF8Row=
Message-ID: <3f9a31f40901120352x5241048x4f0a52c0b8ad44b0@mail.gmail.com>
Date: Mon, 12 Jan 2009 17:22:05 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: build breakage -- paravirt_{alloc,free}_ldt
Cc: "Jiri Kosina" <jkosina@suse.cz>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       linux-kernel@vger.kernel.org,
       "Jaswinder Singh Rajput" <jaswinderrajput@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20090112113923.GC21051@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.10.0901121121410.5377@jikos.suse.cz>
	 <20090112105202.GF10405@elte.hu>
	 <alpine.LNX.1.10.0901121211000.5377@jikos.suse.cz>
	 <3f9a31f40901120319l4fac84e4me193fb314bdbbcaa@mail.gmail.com>
	 <20090112112458.GA19388@elte.hu>
	 <3f9a31f40901120336p5ef464e8ta4a9eac2b397b5f6@mail.gmail.com>
	 <20090112113923.GC21051@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 5:09 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>> It works for me for my old 166 MHz pentium machine after crashing the
>> system, 'git diff' tells which files are broken ;-)
>
> That's cool from Git :-)
>
> Thinking about it, it might not necessarily detect all corruption patterns
> though: git diff is sys_lstat() driven - so if a corruption corrupts a
> single block on the filesystem (in a working tree file), git diff wont
> know about that.
>

I face these problems very often when I compile kernel in old 166 MHz
machine system often freezes during compilation and that machine is
having ext2 filesystem after rebooting the system some inodes are
deleted and then I start getting funny errors. So 'git diff' tells me
which files are broken and then 'git reset --hard origin' again
provide me working system :-)

--
JSR
