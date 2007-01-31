Return-Path: <linux-kernel-owner+w=401wt.eu-S933179AbXAaMmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbXAaMmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbXAaMmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:42:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:48598 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146AbXAaMmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:42:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:sender;
        b=fI/cqJsbJws49UDMpU3btdq4RB7bfUMz80ITNQgKS6TnVG0IIbIxc6L1y+30mA0nCqT6teOSvBW1pKhoO887aVsqf77JxG2KnoDkYEm7fqrYer+938cTnqkzTwdom8r5WnKgdfVIw7M7M6KNmROyDFbUMlr8L0kc+qxghExAGDk=
Message-ID: <45C08EA6.9070504@web.de>
Date: Wed, 31 Jan 2007 13:42:14 +0100
From: Markus Wenke <M.Wenke@web.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.2pre) Gecko/20070111 SeaMonkey/1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Try to fill route cache
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I try to test a programm, that manages ca. 120000 connections at the
same time.

Now I want to test it with a full route cache. I can only test it from
some Test-PC's.
So the route cache ist nearly empty all the time.

I tried to fill the route cache with pktgen amongst others with the
appended configuration, but my route cache is always nearly empty.
In my log this error appears:  "eth0: too many iterations (6) in
nv_nic_irq."

I use Kernel "2.6.16.13-4-smp".

Where is the problem ?


Thanks in advance

Markus Wenke


------------------------------------
CLONE_SKB="clone_skb 1"
PKT_SIZE="pkt_size 60"
#COUNT="count 0"
COUNT="count 10000000"


PGDEV=/proc/net/pktgen/eth0
echo "Configuring $PGDEV"
pgset "$COUNT"
pgset "$CLONE_SKB"
pgset "$PKT_SIZE"
pgset "flag IPDST_RND"
pgset "dst_min 5.0.0.0"
pgset "dst_max 5.255.255.255"
pgset "flows 32768"
pgset "flowlen 10"
----------------------------------


