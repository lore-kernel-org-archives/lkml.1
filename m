Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbXDLOgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbXDLOgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 10:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932279AbXDLOgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 10:36:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:25653 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282AbXDLOgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 10:36:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=uquoIX4deLxXqKjDZoy3WcJd1Qalur/Orbjcm96AeLSfwhA6nCbkL2ngiYLHomQ4Zg8ows8DgcKMq1nKAI4Pyl4MOxbiVSp2gx8srd62kXT2mi2ckTbce1XBWeW1zqtU3wNUupzf4jtvG6hB5SVk9w1vHD7KLJlbUqStHRKydr4=
Date: Thu, 12 Apr 2007 17:36:26 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <1734853889.20070412173626@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Anton Vorontsov <cbou@mail.ru>, dwmw2@infradead.org,
       <linux-kernel@vger.kernel.org>, <kernel-discuss@handhelds.org>
Subject: Re: [Kernel-discuss] Re: [PATCH 3/7] [RFC] Battery monitoring class
In-Reply-To: <20070412142430.GA31240@srcf.ucam.org>
References: <20070411232503.GC20095@zarina> <20070412130817.GA29900@srcf.ucam.org> <20070412141505.GA25552@zarina> <20070412142430.GA31240@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Matthew,

Thursday, April 12, 2007, 5:24:30 PM, you wrote:

> On Thu, Apr 12, 2007 at 06:15:05PM +0400, Anton Vorontsov wrote:
>> On Thu, Apr 12, 2007 at 02:08:18PM +0100, Matthew Garrett wrote:
>> > ACPI batteries can report capacity and rate in either mA or mW. Given
>> 
>> You sure, capacity in mA? Then I don't know. But you can safely
>> fallback and create your own attribute (just as in David's battery class,
>> where every battery required to create its own attributes), plus create
>> capacity_units attribute. So, user space will know your driver's specific
>> units.

> Well, mAh, but yes. Clearly it's possible to add extra attributes, but
> speccing standard attributes that don't entirely cover the most common
> non-embedded battery class seems less than ideal. Why not just require
> capacity_units and rate_units attributes?

  Yes, that's apparently the way to go. We just should consider
if mAh and mWh are enough, or we go wider and allow whole collection of
units. Btw, original handhelds.org code used Joules ;-).


-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

