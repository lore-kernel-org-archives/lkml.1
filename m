Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbYHOFeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbYHOFeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 01:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYHOFdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 01:33:51 -0400
Received: from mail.lang.hm ([64.81.33.126]:54946 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYHOFdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 01:33:50 -0400
Date: Thu, 14 Aug 2008 22:33:30 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Eric Paris <eparis@redhat.com>
cc: Theodore Tso <tytso@mit.edu>, Rik van Riel <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       Pavel Machek <pavel@suse.cz>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to	alinuxinterfaceforon
 access scanning
In-Reply-To: <alpine.DEB.1.10.0808142212430.12859@asgard.lang.hm>
Message-ID: <alpine.DEB.1.10.0808142228450.12859@asgard.lang.hm>
References: <20080813125638.GB6995@ucw.cz>  <20080813135207.CC08C3765BC@pmx1.sophos.com>  <20080814125410.GA2262@elf.ucw.cz>  <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com>  <20080814223918.GC6370@elf.ucw.cz>  <20080814200005.6b363716@bree.surriel.com>
 <20080815004335.GF13048@mit.edu> <1218769209.16613.31.camel@localhost.localdomain> <alpine.DEB.1.10.0808142212430.12859@asgard.lang.hm>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, david@lang.hm wrote:

> again, libmalware.so is not referring to any specific body of code, it's 
> referring to the concept that the handling of open/mmap/read/etc and scanning 
> is done via a userspace library rather then by the kernel. if everyone can 
> agree on that concept then hashing out the details of _which_ library it gets 
> put in is a smaller detail.

one reason to layer scanners is that you could have one that just checks 
to see if the file was deployed from a OS package, if it was (and still 
has the same hash as the package manager thinks it should have) it sets a 
flag that other scanners could look for (if they see it they can skip 
scanning the file)

David Lang
