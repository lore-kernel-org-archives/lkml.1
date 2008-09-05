Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbYIEIxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbYIEIxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 04:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYIEIww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 04:52:52 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:3032 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYIEIwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 04:52:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ba83gI9Vk+VyK/updasb7hVt6DVHJzV0DBcd1xn8PplYBlQag5nc/0vNm2UKBGEO17
         jCXiyBpSmkNKyTEjN2eOXpY/Z36JH1nm5gKRKE33WzKBFNPKz46gFom7khyO2d6PLmcm
         x3eOOm+1gj9J9KMk5kgdRARxjwtyB1bCcmyWc=
Message-ID: <86802c440809050152p734f54bex60ae512361d79f93@mail.gmail.com>
Date: Fri, 5 Sep 2008 01:52:49 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Jordan Crouse" <jordan.crouse@amd.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 - fix v7
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080904190457.GB24990@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220254284-29532-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080904190457.GB24990@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2008 at 12:04 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>> v7: remove wrong removing of write_unlock(&resource_lock) in adjust_resource()
>
> i've applied the generic commit below to tip/core/resources, and merged
> tip/core/resources into tip/x86/core, and added the remaining e820.c
> oneliner change (attached below as well).
>

wonder if need to put

  x86: split e820 reserved entries record to late v4
  IO resources: add reserve_region_with_split()
  x86: split e820 reserved entries record to late, v7

into 2.6.27 for fix hang on David's system.

YH
