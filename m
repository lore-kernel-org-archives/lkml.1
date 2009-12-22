Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbZLVWFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbZLVWFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 17:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZLVWFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 17:05:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:25116 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbZLVWFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 17:05:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,438,1257148800"; 
   d="scan'208";a="525565502"
From: "Smith, GeoffX" <geoffx.smith@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "stable@kernel.org" <stable@kernel.org>
Date: Tue, 22 Dec 2009 14:05:50 -0800
Subject: RE: [PATCH] prctl: return timerslack through pointer
Thread-Topic: [PATCH] prctl: return timerslack through pointer
Thread-Index: AcqDUOIIL8zTjy/8Sc+njMy2rlrr2AAATBjQ
Message-ID: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE17CD@orsmsx510.amr.corp.intel.com>
References: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE12F3@orsmsx510.amr.corp.intel.com>
 <20091222135041.b24abeff.akpm@linux-foundation.org>
In-Reply-To: <20091222135041.b24abeff.akpm@linux-foundation.org>
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

Oops, my oversight.  In re: any patch I submitted 12/17/2009:

Signed-off-by: Geoff Smith <geoffx.smith@intel.com>

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Tuesday, December 22, 2009 1:51 PM
To: Smith, GeoffX
Cc: linux-kernel@vger.kernel.org; Arjan van de Ven; stable@kernel.org
Subject: Re: [PATCH] prctl: return timerslack through pointer

On Thu, 17 Dec 2009 16:17:15 -0800
"Smith, GeoffX" <geoffx.smith@intel.com> wrote:

> This patch fixes the semantics of prctl() option PR_GET_TIMERSLACK
> to pass the return value through *arg2.
> 
> With this change, the option now follows the same conventions as the
> other "get" options added since 2.6.0, and also brings it into
> conformance with the advice in chapter 16 of Documentation/CodingStyle.
> 
> In addition, it effectively doubles the range of time slack to 4.29
> seconds (on a 32-bit architecture).
> 
> The timer slack feature was only added in Sep 2009 (new in 2.6.32.1), 
> so there are not any production applications to break.  I have also 
> repaired some unmatched signed/unsigned mismatches in timer slack
> calculations.
> 

If we're going to do this then we should backport the patch into
2.6.32.x as well.  And I agree that there is time to make this change.

> diff --git a/kernel/sys.c b/kernel/sys.c
> index 20ccfb5..e01da12 100644

You omitted the Signed-off-by: line (described in
Documentation/SubmittingPatches).  Please send one.

