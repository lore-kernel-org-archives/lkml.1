Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbYBNSZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbYBNSZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYBNSZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:25:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:22092 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbYBNSZD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:25:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,353,1199692800"; 
   d="scan'208";a="339988506"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
Date: Thu, 14 Feb 2008 10:24:39 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC943DBD@orsmsx424.amr.corp.intel.com>
In-Reply-To: <adaprv0rygh.fsf@cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
Thread-Index: AchuvHsqX90fNB0WSiea5lzdLkpJVAAehMXg
References: <20080213125725.GC6344@elte.hu><20080213.050340.64342037.davem@davemloft.net><12c511ca0802131659u6e4407d9w96148fe72d6e11d7@mail.gmail.com><20080213.170452.68851396.davem@davemloft.net><12c511ca0802131933g6aaaec9cidbfbfcac6f394c63@mail.gmail.com> <adaprv0rygh.fsf@cisco.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Roland Dreier" <rdreier@cisco.com>
Cc: "David Miller" <davem@davemloft.net>, <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Feb 2008 18:24:55.0807 (UTC) FILETIME=[E60518F0:01C86F36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just curious -- can you reproduce the same problem with
> CONFIG_PRINTK_TIME as I'm seeing?

Yes I can reproduce this (on latest Linus tree).  System
dies with no console output ... looks like the boot cpu
may have taken a machine check (it isn't responding to my
debugger).

-Tony
