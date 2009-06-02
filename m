Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbZFBHF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbZFBHF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759990AbZFBHFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:05:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:63192 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760008AbZFBHFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:05:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sHG18V/BlGpA7nSuc1Q6p0rHnevTed+j/06Rif7F5NUn1duZy3jUjzrZDob3kuZfTL
         l9Cs7HhMNEqRlRbsju3jNruDYIuvNAOtQRldaIKMNbxqWB7KJXRHGp50bLahpA8oPZQc
         UeYZGkqXobyewslfevqnv0wnsYNsu1Hc12814=
MIME-Version: 1.0
In-Reply-To: <200906020110.06135.elendil@planet.nl>
References: <3877989d0906010201j438a08a8x559f62b0aed40696@mail.gmail.com>
	 <200906020110.06135.elendil@planet.nl>
Date: Tue, 2 Jun 2009 15:05:44 +0800
Message-ID: <3877989d0906020005v2dc3830ala2ee688b524c5ab0@mail.gmail.com>
Subject: Re: [RFC patch] reset TSC at the begining of check_tsc_warp
From: Luming Yu <luming.yu@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 2, 2009 at 7:10 AM, Frans Pop <elendil@planet.nl> wrote:
> Luming Yu wrote:
>> Without this patch, we always get kernel warning that TSC warp between
>> CPUs, and TSC is marked unstable due to check_tsc_sync_source failed if
>> the CPUs have the problem of not-synced initial TSC.
>>
>> It hurts CPUs with constant-tsc feature, but with unsynced initial TSC
>> value...
>>
>> The downside is we could break perfect synced TSC with this patch.
>> Please review, test and apply.
>
> I've tested this on my desktop (working TSC) and my laptop (non-working TSC).
> On both machines the patch didn't make any difference.

Thanks for testing, but if there was no warnings like
"Measured 439164 cycles TSC warp between CPUs, turning off TSC clock."
the patch won't help....

--Luming
