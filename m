Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636Ab0ADRai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0ADRai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422Ab0ADRah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:30:37 -0500
Received: from mga14.intel.com ([143.182.124.37]:65067 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab0ADRag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:30:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="229014999"
From: "Smith, GeoffX" <geoffx.smith@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 4 Jan 2010 09:29:21 -0800
Subject: RE: [PATCH] proc: Get/set timer slack through /proc
Thread-Topic: [PATCH] proc: Get/set timer slack through /proc
Thread-Index: AcqLN9oGLR0i9eaOShOvycGHL2kqwACJANWQ
Message-ID: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1DE7@orsmsx510.amr.corp.intel.com>
References: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1D19@orsmsx510.amr.corp.intel.com>
 <20100101151437.17834b25@infradead.org>
In-Reply-To: <20100101151437.17834b25@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday, January 01, 2010, Arjan@infradead.org wrote:

>On Thu, 31 Dec 2009 13:01:49 -0800 
>"Smith, GeoffX" <geoffx.smith@intel.com> wrote:
>
>> Subject: Get/set timer_slack_ns through /proc
>>
>> This patch makes the timer_slack_ns parameter accessible through
>> the /proc system.
>>
>> On 9/1/2008, arjan@linux.intel.com submitted a patch to allow a
>> process to set the timer slack value as part of the range timers
>> feature.  Further, he noted that "Applications and admins can
>> override this [the timer slack value] via the prctl()."
>>
>> We have found this feature useful in attempting to reduce system
>> wakeups caused by timer interrupts.  But we have also found that
>> while applications can set their own timer slack value, there is no
>> provision for setting the timer slack for another process -- prctl()
>> only operates on the current process.
>
>this statement is incorrect btw;
>timerslack is explicitly inherited over exec, so you can have (and we
>do have) a utility similar to the nice program, that launches an
>application with a specific timer slack.

Hmmm, that seems a lot less flexible, but I see how that would work.

Nonetheless, using "nice" as a model is that you would have to modify anything that launches applications, right?  This would mean modifying /etc/init.d and application scripts, which seems beyond the scope of "admin".   Or am I missing something?


