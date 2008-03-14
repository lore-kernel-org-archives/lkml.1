Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbYCNSBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbYCNSBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbYCNSBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:01:14 -0400
Received: from mail.lang.hm ([64.81.33.126]:52498 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbYCNSBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:01:13 -0400
Date: Fri, 14 Mar 2008 11:03:42 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Theodore Tso <tytso@mit.edu>
cc: Ric Wheeler <ric@emc.com>, Benny Amorsen <benny+usenet@amorsen.dk>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
In-Reply-To: <20080314164952.GA7767@mit.edu>
Message-ID: <alpine.DEB.1.00.0803141102010.9040@asgard.lang.hm>
References: <200803110450.19390.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de> <200803111602.53835.phillips@phunq.net> <m3d4q08477.fsf@ursa.amorsen.dk> <20080312133001.1668f40d@the-village.bc.nu> <20080314093019.GA5966@ucw.cz> <47DA5C8D.2020207@emc.com>
 <m3fxutcz2s.fsf@ursa.amorsen.dk> <20080314125656.GA7412@mit.edu> <47DA9DF8.5010600@emc.com> <20080314164952.GA7767@mit.edu>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008, Theodore Tso wrote:

> It depends on the workload, obviously.  I thought I remember someone
> on this thread talking about benchmark where they went from ~2000 to
> ~20 ops/sec once they added fsync().  I'm sure that was an extreme
> benchmarking workload that isn't at all representative of real-life
> usage, where you're usually do something else modifying the metadata
> of many tiny files over and over again.  :-)

I've seen this sort of thing with syslog, normal syslog at ~100 logs/sec, 
syslog without fsync >10,000 logs/sec.

if this is your situation then battery backed cache on your controller is 
the answer as it gives you almost full speed with the safety of fsync.

David Lang

