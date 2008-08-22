Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbYHVEsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbYHVEsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 00:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbYHVEsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 00:48:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:62094 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYHVEsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 00:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Rybd813779PRVHEvb85rEtdBl9uagyre/EFArPUKp8aWH2LUtcJfg6aSLpjKbANobP
         NF3ngFkoWCd64huilyHQXAzrUUf5QslLajT3l9I5Erh7+VhLi9LcJoyzsTyBuCkQWkIh
         Pk1Ad7ew0EStVj+OvvDdFqaTxHlZIcXmRdydw=
Message-ID: <86802c440808212148k74e56fa2mdb2e329ed4df1271@mail.gmail.com>
Date: Thu, 21 Aug 2008 21:48:41 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Cc: "Joshua Hoblitt" <josh@hoblitt.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
In-Reply-To: <20080822035609.GD30284@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080822001047.GF23377@hoblitt.com>
	 <20080822002952.GG23377@hoblitt.com>
	 <20080822010014.GH23377@hoblitt.com>
	 <20080822011055.GI23377@hoblitt.com>
	 <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com>
	 <20080822021512.GJ23377@hoblitt.com>
	 <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com>
	 <86802c440808212024v3ccd2a7ey6517c180464275f0@mail.gmail.com>
	 <20080822035024.GB30284@elte.hu> <20080822035609.GD30284@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 8:56 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> i've tidied up your patch (see the commit below) and have queued it up
>> in x86/urgent. It seems fairly safe and i guess we can push it to
>> v2.6.27 if Joshua reports test success. Joshua, could you give it a go
>> please?
>
> or just try the latest tip/master - please check whether you are getting
> the right amount of RAM out of box plus this warning message:
>
>> WARN_ON("mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
>

according to his dmesg, it works.

may need to change it to WARN_ON only print one time

YH
