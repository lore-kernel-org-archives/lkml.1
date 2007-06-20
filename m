Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbXFTREU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbXFTREU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbXFTREJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:04:09 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37986 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbXFTREH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:04:07 -0400
In-Reply-To: <1182299263.6504.8.camel@heimdal.trondhjem.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: akpm@linux-foundation.org, alan <alan@clueserver.org>,
       Chris Snook <csnook@redhat.com>, hpa@zytor.com,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       viro@zeniv.linux.org.uk
MIME-Version: 1.0
Subject: Re: Versioning file system
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF1BE97403.60074CE1-ON88257300.005C4F4A-88257300.005DC171@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Wed, 20 Jun 2007 10:04:07 -0700
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V80_M5_05202007|May 20, 2007) at
 06/20/2007 13:04:05,
	Serialize complete at 06/20/2007 13:04:05
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>The directory is quite visible with a standard 'ls -a'. Instead,
>they simply mark it as a separate volume/filesystem: i.e. the fsid
>differs when you call stat(). The whole thing ends up acting rather like
>our bind mounts.

Hmm.  So it breaks user space quite a bit.  By break, I mean uses that 
work with more conventional filesystems stop working if you switch to 
NetAp.  Most programs that operate on directory trees willingly cross 
filesystems, right?  Even ones that give you an option, such as GNU cp, 
don't by default.

But if the implementation is, as described, wildly successful, that means 
users are willing to tolerate this level of breakage, so it could be used 
for versioning too.

But I think I'd rather see a truly hidden directory for this (visible only 
when looked up explicitly).

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

