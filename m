Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYAFDPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYAFDPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 22:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYAFDOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 22:14:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:34694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbYAFDOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:14:15 -0500
Date: Sun, 6 Jan 2008 04:14:12 +0100
From: Andi Kleen <ak@suse.de>
To: David Newall <david@davidnewall.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [2.6.25 patch] remove a.out interpreter for ELF executables
Message-ID: <20080106031412.GC2998@bingen.suse.de>
References: <20080101134749.GJ2360@does.not.exist> <200801011536.32598.ak@suse.de> <20080105013053.b46cd28b.akpm@linux-foundation.org> <20080105094618.GA2304@does.not.exist> <477FB2A5.5010005@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477FB2A5.5010005@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 03:09:01AM +1030, David Newall wrote:
> On Tue, 1 Jan 2008 15:36:32 +0100 Andi Kleen <ak@suse.de> wrote:
>
>> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/remove-aout-interpreter
>>
>> Also removal of the old unused iBCS hooks while I was on it
>>
>> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/remove-ibcs-support
>
> Is iBCS support the basis for SCO & SVr4 support?  (These both sound 
> useful.)

Yes, but that always required an external patchkit which AFAIK existed
only for 2.4. The point is that if you have to apply an external
patchkit anyways you can as well apply the small patches for these hooks 
too. But it doesn't make sense to carry the (admittedly minor) overhead
for this in all kernels. Also the ELF loader is quite hairy code
and any simplification of it helps.

-Andi
