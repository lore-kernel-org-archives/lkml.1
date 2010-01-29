Return-Path: <linux-kernel-owner+w=401wt.eu-S932329Ab0A2LN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab0A2LN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 06:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733Ab0A2LN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 06:13:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64283 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab0A2LN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 06:13:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=wy0Yl+jkORauY27bk2mvcKuGqOOx0YOZO7yAIWiZSyfaHbFco7s429vdnoLqD8xTQj
         H5S1srGQgfduw6JYM3adNBFKcFV0uvH7XyZK3DnHa1+I2tGZqT4jDbbOKZg6cKQNc5Z0
         kqbBXgti+rEk2RM0MrLqMjUavTM3gIgZHdjLA=
MIME-Version: 1.0
In-Reply-To: <1264763149.4283.2215.camel@laptop>
References: <20100122155044.391857484@chello.nl>
	 <20100122155535.797688466@chello.nl>
	 <520f0cf11001290232p38140fb2sa5da1b7f8e2704cc@mail.gmail.com>
	 <1264763149.4283.2215.camel@laptop>
Date: Fri, 29 Jan 2010 12:13:25 +0100
X-Google-Sender-Auth: e64ec4406b62b8e1
Message-ID: <520f0cf11001290313t3aa14cb0i4bc971b537709ccf@mail.gmail.com>
Subject: Re: [PATCH 07/10] bitops: Provide compile time HWEIGHT{8,16,32,64}
From: John Kacur <jkacur@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com, fweisbec@gmail.com, paulus@samba.org, mingo@elte.hu,
       davem@davemloft.net, robert.richter@amd.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 12:05 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-01-29 at 11:32 +0100, John Kacur wrote:
>>
>> I like it. Maybe provide a comment that this provides the Hamming weight, it
>> took me a second to realize what this was.
>
> its called _H_weight for crying out loud.
>

Ha. :) You're right, but it's always obvious when your hands are dirty with
algorithms that can use it. Easy to forget when you're working on other stuff.
Put the term in there so we can google it more easily.
