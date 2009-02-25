Return-Path: <linux-kernel-owner+w=401wt.eu-S1761839AbZBYJ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761839AbZBYJ4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZBYJ4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:56:03 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:6831 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585AbZBYJ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:56:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ChhGXCOPKBTCCqJ8CRIhZ9jXjOJLLlaijGGNp9NMFX/QLcRd/PjHfh+UTxRWw7APIz
         gDsgLzzw9QFGA/QufBW8hGA5bJnAn+AmIcfV2EoYHWWw1GMNuCTvkA1quzTLe7FKkYFe
         N/kBWpuMiwyYsMs4ORMAzFFyic5bLyOVLyxRI=
MIME-Version: 1.0
In-Reply-To: <5d5443650902250003g7df7093bn59e0fc052ffb6ed@mail.gmail.com>
References: <20090225044730.GA9106@july>
	 <5d5443650902250003g7df7093bn59e0fc052ffb6ed@mail.gmail.com>
Date: Wed, 25 Feb 2009 18:55:58 +0900
X-Google-Sender-Auth: 3128f8be545a6b14
Message-ID: <9c9fda240902250155p107fb657wafcd4aa92f7e093d@mail.gmail.com>
Subject: Re: [PATCH] Input notifier support
From: Kyungmin Park <kmpark@infradead.org>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Feb 25, 2009 at 5:03 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
> Hi Kyungmin,
>
> On Wed, Feb 25, 2009 at 10:17 AM, Kyungmin Park <kmpark@infradead.org> wrote:
>> Some hardware doesn't connected with key button and led. In this case key should be connected with led by software. Of course each application can control it however it's too big burden to application programmer.
>>
>
> I am not able to understand this.

it's simple there's one led and it's for key input. so when there's
key input, it's blink. that's all

>
>> So add input notifier and then use it at other frameworks such as led.
>> Of course, other input device can use this one.
>
> If it is just LED, then you may write some led-input-trigger?

Please see the LED key input trigger patch.

Thank you,
Kyungmin Park
