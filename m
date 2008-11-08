Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbYKHWOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbYKHWOG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 17:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYKHWNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 17:13:54 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:42015 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbYKHWNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 17:13:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xfVtiHNsTHy5+ZRmk1xjPsrVa+LQcpXIkq/3jLYnztUHJkk9xUp/NJ1/+4+1mvlasB
         S19IBzihv64PH0oKaBW/0CRCSzQsHdkjpP05lNuK6BwVJAXmf461P8S3GR57tRvcwLja
         0ZCKv0GsA/wytQ6QkQjM965eMzdWmVaefV4NY=
Message-ID: <86802c440811081413v58ffb2fah90849e7aa26cc67f@mail.gmail.com>
Date: Sat, 8 Nov 2008 14:13:53 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] irq: Maintain user set affinity
Cc: "Kumar Gala" <galak@kernel.crashing.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20081106133524.75588d96.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0811041030520.25054@blarg.am.freescale.net>
	 <20081106133524.75588d96.akpm@linux-foundation.org>
X-Google-Sender-Auth: 5b6765a164e61141
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2008 at 1:35 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 4 Nov 2008 10:31:05 -0600 (CST)
> Kumar Gala <galak@kernel.crashing.org> wrote:
>
>> >From 819ad3ed4660f4238e053728a8b5aa93d22b13d7 Mon Sep 17 00:00:00 2001
>> From: Kumar Gala <galak@kernel.crashing.org>
>> Date: Tue, 4 Nov 2008 10:13:53 -0600
>> Subject: [PATCH 1/1] irq: Maintain user set affinity
>>
>> This addresses a regression in that if a user specified an affinity
>> for an interrupt that affinity information would get reset between
>> a request_irq(), free_irq() and request_irq() for the same irq.
>>
...
>
> Are you able to identify when this regression occurred?  It isn't
> immediately obvious to me.
>
> If the regression is present in 2.6.27 or earlier, do you think we
> should backport the fix?  If so, a different patch would be needed due
> to the presence of

it seems that is not a regression...

YH
