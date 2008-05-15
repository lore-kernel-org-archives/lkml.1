Return-Path: <linux-kernel-owner+w=401wt.eu-S1763851AbYEOSUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763851AbYEOSUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYEOSUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:20:00 -0400
Received: from smtp2e.orange.fr ([80.12.242.113]:9590 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbYEOST7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:19:59 -0400
X-ME-UUID: 20080515181957151.03B02700008B@mwinf2e26.orange.fr
Message-ID: <482C7EBC.3030708@cosmosbay.com>
Date: Thu, 15 May 2008 20:19:40 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Lameter <clameter@sgi.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
References: <20080510030919.604216074@sgi.com> <4825709A.2020407@firstfloor.org> <20080510221515.3540a6cc@bree.surriel.com> <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com> <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com> <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com> <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com> <1210822002.3177.121.camel@ymzhang> <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com> <20080515174953.GN9921@parisc-linux.org>
In-Reply-To: <20080515174953.GN9921@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox a écrit :
> On Thu, May 15, 2008 at 10:05:35AM -0700, Christoph Lameter wrote:
>   
>> Thanks for using the slab statistics. I wish I had these numbers for the 
>> TPC benchmark. That would allow us to understand what is going on while it 
>> is running.
>>     
>
> Hang on, you want slab statistics for the TPC run?  You didn't tell me
> that.  We're trying to gather oprofile data (and having trouble because
> the machine crashes when we start using oprofile -- this is with the git
> tree you/pekka put together for us to test).
>
>   
Hum, you might try to apply commit 
44c81433e8b05dbc85985d939046f10f95901184 or commit
8b8b498836942c0c855333d357d121c0adeefbd9

oprofile data are definitly wanted :)





