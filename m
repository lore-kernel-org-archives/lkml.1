Return-Path: <linux-kernel-owner+w=401wt.eu-S1761085AbYGRUVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761085AbYGRUVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760863AbYGRUVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:21:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:6520 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760281AbYGRUVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:21:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QPooI+QJrioiCSw9yzwuTLCjrXS4OTvGEHeyfoQfy0YSx0Wh7QFjKcizfUNAScy9i7
         gLQcqkvmsz6WE2mBorJz36gYq+G6tQQoTp4SrQaSh5XrUXC4m6lcptUnPbrmFHJ2LS9k
         55sqwFWJyBlXLuDi+vF3P45MsSHn4RqgoaFhY=
Message-ID: <86802c440807181321x4283bb6ev516930891f193e71@mail.gmail.com>
Date: Fri, 18 Jul 2008 13:21:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       jbarnes@virtuousgeek.org, "Jack Howarth" <howarth@bromo.msbb.uc.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080718201953.GB24122@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807180941.09779.yhlu.kernel@gmail.com>
	 <4880D684.7020406@zytor.com>
	 <86802c440807181047y4ef2f227me72e6474e726596@mail.gmail.com>
	 <4880D7B9.8000007@zytor.com>
	 <86802c440807181054p422a77bdv901ebdc44a8d1b43@mail.gmail.com>
	 <20080718201953.GB24122@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 1:19 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> > That would make sense, since you're truncating the mmconf range
>> > based on some arbitrary limit.  Even better would be to query the
>> > hardware register which is responsible for the truncation.
>>
>> OK
>>
>> will rework pci_mmcfg_reject_broken to reduce size and check with
>> is_acpi_reserved/e820_mapped to update end_bus_number
>
> should we apply your current patch (because that is what got tested by
> Jack), with a followup patch - or would you like to send a new patch
> from scratch?

will send one new patch replace this in seconds.

YH
