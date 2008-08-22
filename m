Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbYHVS5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbYHVS5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYHVS5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:57:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:63598 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbYHVS5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xxp/gzLjVve+of6rQyd2QaVbUxChZhliVN6z0g7p3+EkCEniZY1Ikp+uFbhyjoFwc+
         7lD3r2ZeGf1xriFjNRwoatC8tnQ9eD64X4clgwMBj8CHP/gBF+KeG0RHJGal4/Sh2wQm
         m6iL6omCwIiN5fvqluRLDkDtc/IVI5toLMAss=
Message-ID: <86802c440808221157v7578c984v571799763df5dab7@mail.gmail.com>
Date: Fri, 22 Aug 2008 11:57:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [PATCH] x86: fix: do not run code in amd_bus.c on non-AMD CPUs
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Jan Beulich" <jbeulich@novell.com>
In-Reply-To: <20080822185134.GA14103@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD82D5.76E4.0078.0@novell.com>
	 <1219429418-29023-1-git-send-email-robert.richter@amd.com>
	 <86802c440808221147h4fb3c26cw31970678a100e2fc@mail.gmail.com>
	 <20080822185134.GA14103@erda.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 11:51 AM, Robert Richter <robert.richter@amd.com> wrote:
> On 22.08.08 11:47:45, Yinghai Lu wrote:
>> 1. early_fill_mp_bus_info has checking with vendor/deviceid in itself.
>
> Right, but scanning the pci bus could be skipped for non-AMD cpus. If
> you don't like this check for your function I will resubmit a new
> patch.

just fine, if you check vendor before that, we should remove check
vendor again in later function.

YH
