Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYCQNz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYCQNz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 09:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYCQNzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 09:55:12 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:13690 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYCQNzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 09:55:11 -0400
Message-ID: <47DE7780.2000505@emc.com>
Date: Mon, 17 Mar 2008 09:52:00 -0400
From: Ric Wheeler <ric@emc.com>
Reply-To: ric@emc.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: david@lang.hm, David Newall <davidn@davidnewall.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803162252.58274.phillips@phunq.net> <alpine.DEB.1.00.0803162341340.14887@asgard.lang.hm> <200803170116.19546.phillips@phunq.net>
In-Reply-To: <200803170116.19546.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.53115
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> On Sunday 16 March 2008 23:49, david@lang.hm wrote:
>>> Mirroring on the other hand, makes a realtime copy of a volume, that is
>>> never out of date.
>> so just mirror to a local disk array then.
> 
> Great idea.  Except that the disk array has millisecond level latency,
> when what we trying to achieve is microsecond level latency.

Just a point of information, most of the mid-tier and above disk arrays 
can do replication/mirroring behind the scene (i.e., you write to one 
array and it takes care of replicating your write to one or more other 
arrays).  This behind the scene replication can be over various types of 
connections - IP or fibre channel probably are the two most common paths.

That will still leave you with the normal latency for a small write to 
an array which is (when you hit cache) order of 1-2 ms...

ric
