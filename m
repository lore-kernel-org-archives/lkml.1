Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYDOWrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYDOWrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 18:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYDOWr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 18:47:28 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43432 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbYDOWr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 18:47:27 -0400
Date: Tue, 15 Apr 2008 16:18:18 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
In-reply-to: <Pine.LNX.4.64.0804151455520.4038@schroedinger.engr.sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Message-id: <200804151618.25588.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
 <20080415215504.GA9066@elte.hu>
 <Pine.LNX.4.64.0804151455520.4038@schroedinger.engr.sgi.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 April 2008 03:06:28 pm Christoph Lameter wrote:
> On Tue, 15 Apr 2008, Ingo Molnar wrote:
> 
> > grumble. Do you read my bugreports?
> 
> Cannot memorize everything sorry. This looked like slab object corruption 
> and there were no slub diagnostics in the log.
> 
> Trying to duplicate the issue here.
> 
> Boot with PAE support on a machine with 8G RAM 8 processors here works 
> fine.
> 
> Also booting without highmem support (SMP) works fine. 
> 
> On how many machines does the problem occur?

same .config  with -rc9 on one system with 128g 4 sockets with quad core crashed here too.

YH
