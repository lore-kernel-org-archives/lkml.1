Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbYH3VuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbYH3VuF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbYH3Vtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:49:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:55454 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbYH3Vty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:49:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D3VdBNPK753zDEHafY+duBFqnuP4iMx2VWpQ9bQhFhw8BYPqAtJAdxZjxebx55yD2Z
         ob+hYTFgNrda7icKJCnzTWpQ3YPDr6koiVUij4a+XLnZwDeKgXClvSIaStdthU7pKq7x
         TmFavkC+rRGVN8eK8Cd046Q7pMsbjwTwtl0ww=
Message-ID: <86802c440808301449s72aa10e7k5b408883d2e5f99@mail.gmail.com>
Date: Sat, 30 Aug 2008 14:49:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <200808302334.29156.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <86802c440808301412k4e0b5562ie03ce41547ddab9a@mail.gmail.com>
	 <86802c440808301413g7f496e8bxd21adc60b328cd24@mail.gmail.com>
	 <200808302334.29156.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 2:34 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, 30 of August 2008, Yinghai Lu wrote:
>> On Sat, Aug 30, 2008 at 2:12 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> > On Sat, Aug 30, 2008 at 1:46 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> On Saturday, 30 of August 2008, Yinghai Lu wrote:
>> >>> please check
>> >>>
>> >>> [PATCH] x86: split e820 reserved entries record to late v4
>> >>> [PATCH] x86: split e820 reserved entries record to late v4 - fix v6
>> >>
>> >> What kernel should I apply those to and in what order?
>> >
>> > linus git tree
>> > 1. [PATCH] x86: split e820 reserved entries record to late v4
>> > 2. [PATCH] x86: split e820 reserved entries record to late v4 - fix v6
>> >
>> > tip/master
>> > 1. Resource handling: add 'insert_resource_expand_to_fit()' function
>> > 2. [PATCH] x86: split e820 reserved entries record to late v4 - fix v6
>>
>> actually it is almost the same to tar ball send you for your system...
>
> I've just tested these two patches on top of the current Linus' tree and the
> system works normally.

thanks,

David, can you test those two patches on top of linus tree?

YH
