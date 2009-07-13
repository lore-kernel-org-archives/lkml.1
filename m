Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbZGMV34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbZGMV34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZGMV34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:29:56 -0400
Received: from smtp-out.google.com ([216.239.33.17]:11385 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZGMV3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:29:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=DDWHUofAE62lL7mXP7oahjkt6cfAnweo0y6XCH3o0wS4D6VNEWG07GvxrHAqZkV8O
	B4l8bEwN6eO6dLLn2JNXA==
MIME-Version: 1.0
In-Reply-To: <20090710081851.GY23611@kernel.dk>
References: <20090709204759.GF30832@redhat.com> <20090709205108.GG30832@redhat.com> 
	<20090710081851.GY23611@kernel.dk>
From: Divyesh Shah <dpshah@google.com>
Date: Mon, 13 Jul 2009 14:29:30 -0700
Message-ID: <af41c7c40907131429m3611eb39ya48f7513f7901dcc@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: no need to keep track of busy_rt_queues
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Moyer Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change looks good to me too.

On Fri, Jul 10, 2009 at 1:18 AM, Jens Axboe<jens.axboe@oracle.com> wrote:
> On Thu, Jul 09 2009, Vivek Goyal wrote:
>> Resending as had forgotten to put "[PATCH]" in subject line.
>>
>> o Get rid of busy_rt_queues infrastructure. Looks like it is redundant.
>>
>> o Once an RT queue gets request it will preempt any of the BE or IDLE queues
>>   immediately. Otherwise this queue will be put on service tree and scheduler
>>   will anyway select this queue before any of the BE or IDLE queue. Hence
>>   looks like there is no need to keep track of how many busy RT queues are
>>   currently on service tree.
>
> Looks good, I'll queue this up for 2.6.32.
>
> --
> Jens Axboe
>
>
