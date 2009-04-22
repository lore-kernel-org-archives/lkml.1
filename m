Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZDVTl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZDVTl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZDVTlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:41:50 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:22283 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZDVTlu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:41:50 -0400
X-IronPort-AV: E=Sophos;i="4.40,231,1238976000"; 
   d="scan'208";a="157825445"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Proc entry to know task/thread sleep time
Date: Wed, 22 Apr 2009 12:41:45 -0700
Message-ID: <9E88C8678BF34240A8C61D4078A3D251F7940F@xmb-sjc-23e.amer.cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Proc entry to know task/thread sleep time
Thread-Index: AcnDgZXUDCCDHl0dRdWQlDYyM1jFIQAAH5Mg
From: "Venky Venkatesh (venky)" <venky@cisco.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Apr 2009 19:41:48.0704 (UTC) FILETIME=[60631200:01C9C382]
Authentication-Results: sj-dkim-4; header.From=venky@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi,
I am looking for any proc entry/tool which would provide the time for
which a thread/task has been sleeping. The use of this is the following:
I have a multi-threaded application and I am trying to determine the
extent of multi-processing between threads i.e. determine how much time
threads spend on blocking for resources/each other Vs doing productive
work. 
If the above is available, is there an additional info on
time-waiting-on-io (i.e. a subset of the above sleep time) that is also
available thru a proc entry/tool? This would find use in a server like
application where if all the current threads are spending most of their
time waiting on I/O then can add more threads.
In general if there is a proc entry which accounts for time spent by a
thread in various states that could also help.
	 
Thanx
-Venky

