Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870Ab0AUQYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0AUQYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325Ab0AUQYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:24:18 -0500
Received: from mailgate5.roche.com ([196.3.51.113]:9723 "EHLO
	mailgate5.roche.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab0AUQYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:24:17 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jan 2010 11:24:17 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 0/3] sched: Make Priority Inheritance POSIX compliant
Date: Thu, 21 Jan 2010 17:16:23 +0100
Message-ID: <BB799A2B2CEBA34FB65A89BA76EEA099082D4DF6@rkamsem1.emea.roche.com>
In-Reply-To: <20100120171231.922420383@linutronix.de>
Thread-Topic: [patch 0/3] sched: Make Priority Inheritance POSIX compliant
Thread-Index: AcqaFpPYght6hnXyQuSqzh6gQwjSdQAnQBZA
References: <20100120171231.922420383@linutronix.de>
From: "Weber, Mathias" <mathias.weber.mw1@roche.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Carsten Emde" <cbe@osadl.org>
X-OriginalArrivalTime: 21 Jan 2010 16:17:16.0513 (UTC) FILETIME=[32C6D510:01CA9AB5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 09:58 PM, Thomas Gleixner wrote:
>The current PI implementation violates POSIX scheduling semantics when
>a thread is deboosted. The following patch series adresses this.

I did rerun the test case with this patches applied and I can confirm
that this fixes the incorrect scheduling behavior in our test case.

Thanks, Thomas and Carsten for your help.

Tested-by: Mathias Weber <mathias.weber.mw1@oche.com>
