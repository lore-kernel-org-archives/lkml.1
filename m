Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbYFCCDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbYFCCDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 22:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757740AbYFCCCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 22:02:42 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:45404 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758023AbYFCCCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 22:02:40 -0400
Message-ID: <4844A63B.2090509@lougher.demon.co.uk>
Date: Tue, 03 Jun 2008 03:02:35 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Erez Zadok <ezk@cs.sunysb.edu>
CC: Arnd Bergmann <arnd@arndb.de>, Jamie Lokier <jamie@shareable.org>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
References: <200806021813.m52IDgFn015621@agora.fsl.cs.sunysb.edu>
In-Reply-To: <200806021813.m52IDgFn015621@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erez Zadok wrote:
> In message <200806020951.26868.arnd@arndb.de>, Arnd Bergmann writes:
>> On Monday 02 June 2008, Erez Zadok wrote:
> 
>>> Arnd, I favor a more generic approach, one that will work with the vast
>>> majority of file systems that people use w/ unioning, preferably all of
>>> them.  Supporting copy-on-write in cramfs will only help a small subset of
>>> users.  Yes, it might be simple, but I fear it won't be useful enough to
>>> convince existing users of unioning to switch over.  And I don't think we
>>> should add CoW support in every file system -- the complexity will be much
>>> more than using unionfs or some other VFS-based solution.
>> My idea was to have it in cramfs, squashfs and iso9660 at most, I agree
> [...]
> 
> Ah, ok.  Doing those 3 will get better coverage for existing users.  The
> question may come to how much code complexity does it add to each, and
> whether some common code can be excised into generic helpers?
> 

Yes, that's what I'm interested in.  From my reading of the patches, the 
general approach and a lot of the code should be directly useable in a 
fake-writable Squashfs.  The first step (a very big first step) is to 
get readonly Squashfs mainlined, which is what I'm working on at the 
moment.  After that I'll be very interested in looking at fake-write 
support and factoring any common code into generic helpers.

Phillip
