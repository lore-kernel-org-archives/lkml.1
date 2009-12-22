Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZLVWvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZLVWvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 17:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZLVWvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 17:51:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:56211 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbZLVWvF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 17:51:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,438,1257148800"; 
   d="scan'208";a="758532089"
From: "Smith, GeoffX" <geoffx.smith@intel.com>
To: "Smith, GeoffX" <geoffx.smith@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "stable@kernel.org" <stable@kernel.org>
Date: Tue, 22 Dec 2009 14:51:00 -0800
Subject: RE: [PATCH] prctl: return timerslack through pointer
Thread-Topic: [PATCH] prctl: return timerslack through pointer
Thread-Index: AcqDUOIIL8zTjy/8Sc+njMy2rlrr2AAATBjQAAFN9FA=
Message-ID: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE17E0@orsmsx510.amr.corp.intel.com>
References: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE12F3@orsmsx510.amr.corp.intel.com>
 <20091222135041.b24abeff.akpm@linux-foundation.org>
 <354B2877CF17F44BB3FA44EB4DB0E5470C91CE17CD@orsmsx510.amr.corp.intel.com>
In-Reply-To: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE17CD@orsmsx510.amr.corp.intel.com>
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


On December 22, Andrew Morton <akpm@linux-foundation.org> wrote:

> To: Smith, GeoffX
> Cc: linux-kernel@vger.kernel.org; Arjan van de Ven; stable@kernel.org
> Subject: Re: [PATCH] prctl: return timerslack through pointer
>
> On Thu, 17 Dec 2009 16:17:15 -0800
> "Smith, GeoffX" <geoffx.smith@intel.com> wrote:
>
>> This patch fixes the semantics of prctl() option PR_GET_TIMERSLACK
>> to pass the return value through *arg2....
>
> If we're going to do this then we should backport the patch into
> 2.6.32.x as well.  And I agree that there is time to make this change.


The patch applies cleanly to 2.6.32.2 as well as to the mainline.

