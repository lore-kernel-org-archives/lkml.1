Return-Path: <linux-kernel-owner+w=401wt.eu-S1759054AbYBKS1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054AbYBKS1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbYBKS1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:27:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:2937 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbYBKS1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TWi8D53lPTaDfOlKWC1kMG/kH24Q13euZFOJLW17iRhrswqiKgQkUtGnRygX2FhVTHYHVs2BvA2VWMiu76X9r3BtBf4bFkCOLmYkVlUhZp/9+y9GLwO5MqrSi4WSYU6levXR5sS+ukFErQ+FmZx7blpGwjQy946QhMYwtjP79Ws=
Message-ID: <2c0942db0802111027r69b46633n5ac7cd57ea96260d@mail.gmail.com>
Date: Mon, 11 Feb 2008 10:27:08 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Mirco Tischler" <mt-ml@gmx.de>
Subject: Re: [REGRESSION]fan turns at highspeed after suspend2ram
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@suse.cz>, "Len Brown" <len.brown@intel.com>
In-Reply-To: <1202745386.7382.23.camel@mtlp>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202664109.8394.19.camel@mtlp> <200802101954.31061.rjw@sisk.pl>
	 <1202745386.7382.23.camel@mtlp>
X-Google-Sender-Auth: 9672d1c0d44983a1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 11, 2008 7:56 AM, Mirco Tischler <mt-ml@gmx.de> wrote:
> On Sunday, 10 of February 2008, Rafaek J. Wysocki wrote:
>
> > Can you apply the appended patch on top of the current mainline and tetest?
> >
> > Thanks,
> > Rafael
> >
>
> Sorry, that doesn't fix it.
> But I'm pretty sure it is related to that commit. Bisecting went
> straight forward to it and reverting it fixes the bug.
>
> @Ray
> I'm not sure you have the same problem. After waking up from s2ram, only
> my fan runs at highest speed and keeps on, at least for half an hour.
> All other acpi-related stuff works as usual. No sign of a stuck
> ACPI-system.

Yeah, it may just be another bug in this HP laptop.

Regardless, Rafael, I'm using a kernel with the patch applied, and fan
control after a couple of suspends and resumes is looking fine. But
given how inconsistent this laptop is on resume, I may have just had a
string of bad luck, and now several good cases in a row, I don't know.
I'll run with this for a while and see if anything crops up again.
