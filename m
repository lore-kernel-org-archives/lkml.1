Return-Path: <linux-kernel-owner+w=401wt.eu-S1161408AbXBGR5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161408AbXBGR5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 12:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161411AbXBGR5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 12:57:24 -0500
Received: from web38502.mail.mud.yahoo.com ([209.191.125.48]:25473 "HELO
	web38502.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161408AbXBGR5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 12:57:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=o2gzk9PqYLOPuhFK22dauKN8GS9rRxrzCCFXjrKtNVFRm+2heYit+QoWZL9wmrD+c0hdo2QPjiiyFXcR3eZ2TooUhDRxjKemQc71kB/tllFN40VZMWO7nVR0t1A1o36ZaGzweabFm4VdMgnRPmwFk3Te9nzLEK43cneCe+rN3JA=;
X-YMail-OSG: YHq6zzIVM1mA2POLq.EwV8ouHQh9S4Pu65Qemgyy.sQbCW3831G4jt9CLY.8C_9wgXdebrYx7fdI5INefo4PnGbtx1LEPXorCmZ7MvQ324VgoFOyCtKz4ABIeVTBvLFP407E1cotY8a8NPk-
Date: Wed, 7 Feb 2007 09:57:21 -0800 (PST)
From: Levitsky Maxim <maximlevitsky@yahoo.com>
Subject: [PATCH] [NET] dmfe : number of fixes and features
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <131364.59702.qm@web38502.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Before some time I decided to fix suspend/resume on my Davicom network card.
During development I also fixed couple of bugs and added support for link detection and WOL
Note : 2.6.20 already has support for link detection , but it is broken when card has external PHY
, like mine.

So here it goes:

[PATCH] [NET] [001] dmfe : trivial/spelling fixes
[PATCH] [NET] [002] dmfe : Fix possible oops
[PATCH] [NET] [003] dmfe : fix link detection
[PATCH] [NET] [004] dmfe : Add suspend/resume support
[PATCH] [NET] [005] dmfe : Add support for wake-on-lan

        Maxim Levitsky


 
____________________________________________________________________________________
Food fight? Enjoy some healthy debate 
in the Yahoo! Answers Food & Drink Q&A.
http://answers.yahoo.com/dir/?link=list&sid=396545367
