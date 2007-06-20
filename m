Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbXFTRPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbXFTRPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbXFTRPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:15:21 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48185 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbXFTRPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:15:19 -0400
Message-ID: <46795F90.5030602@zytor.com>
Date: Wed, 20 Jun 2007 10:10:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Bryan Henderson <hbryan@us.ibm.com>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>, akpm@linux-foundation.org,
       alan <alan@clueserver.org>, Chris Snook <csnook@redhat.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
References: <OF1BE97403.60074CE1-ON88257300.005C4F4A-88257300.005DC171@us.ibm.com>
In-Reply-To: <OF1BE97403.60074CE1-ON88257300.005C4F4A-88257300.005DC171@us.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Henderson wrote:
>> The directory is quite visible with a standard 'ls -a'. Instead,
>> they simply mark it as a separate volume/filesystem: i.e. the fsid
>> differs when you call stat(). The whole thing ends up acting rather like
>> our bind mounts.
> 
> Hmm.  So it breaks user space quite a bit.  By break, I mean uses that 
> work with more conventional filesystems stop working if you switch to 
> NetAp.  Most programs that operate on directory trees willingly cross 
> filesystems, right?  Even ones that give you an option, such as GNU cp, 
> don't by default.
> 
> But if the implementation is, as described, wildly successful, that means 
> users are willing to tolerate this level of breakage, so it could be used 
> for versioning too.
> 
> But I think I'd rather see a truly hidden directory for this (visible only 
> when looked up explicitly).
> 

When I administered a bunch of netapps I remember turning the visible
.snapshots off.

	-hpa
