Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbYIPTKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbYIPTKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbYIPTKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:10:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56453 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbYIPTKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:10:21 -0400
Message-ID: <48D003F1.50101@redhat.com>
Date: Tue, 16 Sep 2008 15:07:29 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Martin Knoblauch <knobi@knobisoft.de>
CC: linux-kernel@vger.kernel.org, Peter zijlstra <a.p.zijlstra@chello.nl>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: How to find out, what "pdflush" is working on
References: <849662.25086.qm@web32602.mail.mud.yahoo.com>
In-Reply-To: <849662.25086.qm@web32602.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Knoblauch wrote:
> Hi,
> 
> I find the following comment in mm/pdflush.c
> 
> /* * The pdflush threads are worker threads for writing back dirty data. *
> Ideally, we'd like one thread per active disk spindle.  But the disk *
> topology is very hard to divine at this level.   Instead, we take * care in
> various places to prevent more than one pdflush thread from * performing
> writeback against a single filesystem.  pdflush threads * have the PF_FLUSHER
> flag set in current->flags to aid in this. */
> 
> Is there a way to find out what a certain instance of "pdflush" is working
> on? Like which block-device or which fliesystem it is writing to? I am still
> (2.6.27) trying to track down why writing a single file can make linux very
> sluggish and unresponsive. If that happens I usually see all possible 8
> "pdflush" threads being in "D"-state. According to above comment only one of
> them should be really busy.

The key word is "ideally".  We'd like it to work that way, but it doesn't. 
Patches to fix this are welcome.

-- Chris
