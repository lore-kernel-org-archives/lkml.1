Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYCQSgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYCQSgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 14:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYCQSgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 14:36:25 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:44056 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYCQSgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 14:36:24 -0400
From: Chr <chunkeey@web.de>
To: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-crypt] INFO: task mount:11202 blocked for more than 120 seconds
Date: Mon, 17 Mar 2008 19:36:21 +0100
User-Agent: KMail/1.9.9
Cc: Christian Kujau <lists@nerdbynature.de>, Milan Broz <mbroz@redhat.com>,
       David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, dm-devel@redhat.com, dm-crypt@saout.de,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Ritesh Raj Sarraf <rrs@researchut.com>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <alpine.DEB.1.00.0803161406040.6213@sheep.housecafe.de> <20080317173609.GD29322@agk.fab.redhat.com>
In-Reply-To: <20080317173609.GD29322@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171936.22260.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX18cJGI+XRdX+YuIU5FAvCPjVe8Xl3Yg1+PDZzPF
	OEd6Yauoms+7GK4zd5tSCgq05DEMnCWcMlc0TOUwXlNCgOBbb3
	dzcGhURUA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008 18:36:09 Alasdair G Kergon wrote:
> Latest version for everyone to try:
>
> From: Milan Broz <mbroz@redhat.com>
>
> Fix regression in dm-crypt introduced in commit
> 3a7f6c990ad04e6f576a159876c602d14d6f7fef
> (dm crypt: use async crypto).
>
> If write requests need to be split into pieces, the code must not
> process them in parallel because the crypto context cannot be shared.
> So there can be parallel crypto operations on one part of the write,
> but only one write bio can be processed at a time.
>
> This is not optimal and the workqueue code need to be optimized for
> parallel processing, but for now it solves problem without affecting
> the performance of synchronous crypto operation (most of current
> dm-crypt users).
>
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Tested-by: Christian Lamparter <chunkeey@web.de>

Well, the dm-crypt regressions seems to be gone. :)
Thanks for your work & time!

Regards, 
	Christian
