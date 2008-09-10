Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYIJSBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYIJSBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYIJSB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:01:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:47341 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYIJSB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:01:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XDGCf7GTXOvErevSeslHYPo7hwnnwTnHzHWEqV3gBDlq1nd6tnVFs4sh+jG0Xu/wDV
         mSZWMWsUCVcsnLT6TP8cEn7hf8xjm11vbq9yq4uyVqBpfQlZHLREl2lGb1AFlOnalYuL
         hM5lsmdadhlVuo5/OooGxLgc5J1kzsZ+yQU3Y=
Message-ID: <86802c440809101101ld5a98d0yfd9089b6ab8eac1c@mail.gmail.com>
Date: Wed, 10 Sep 2008 11:01:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] pci: fix merging left out for BAR print out v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <200809101048.57119.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220988472-24139-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080910084450.GJ15255@elte.hu>
	 <200809101048.57119.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 10:48 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Wednesday, September 10, 2008 1:44 am Ingo Molnar wrote:
>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> > print out for Device BAR address before kernel try to update them.
>> >
>> > also change it to KERN_DEBUG instead...
>> >
>> > v2: update to linux-pci next
>> >    also add (unsigned long long) cast
>> >
>> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> Jesse, if you want to pick it up, could we please do this via git
>> methods (git-pull and stuff)? The commit below is the one in -tip -
>> should i separate it out?
>
> Sure, though I'm not sure why I shouldn't just be applying this stuff to my
> tree first... Seems weird to pull from you only to then ask Linus to pull.

there is another patch applied to linux-pci next for cast some
resource_t to unsigned-long-long...

anyway, v2 could be applied to linux-pci cleanly.

YH
