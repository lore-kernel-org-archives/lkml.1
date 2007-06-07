Return-Path: <linux-kernel-owner+w=401wt.eu-S935303AbXFGTB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935303AbXFGTB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761609AbXFGTBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:01:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:30645 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbXFGTBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qk52+aI1hhCzmKKNPkgTrDI0Q5nRJqt22oZ0NwMHzyTXwcvseeZ7a/JeJ6lUaxSWvF6dvG7zypstuQTWP9/QbK4IzQ4asjcd9In9PQnbTLUpLe50NmnBAWBVhAw+6VGHioCdeOegVTTwl17qdNhWZt/FJItulh2fF7cYZ0l0mL0=
Message-ID: <75b66ecd0706071201m3068ca5cge65a6d423e110df2@mail.gmail.com>
Date: Thu, 7 Jun 2007 15:01:50 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "kernel coder" <lhrkernelcoder@gmail.com>
Subject: Re: tcp/ip stack question
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f69849430706070550k4780060dheaa0f3073555d137@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f69849430706070550k4780060dheaa0f3073555d137@mail.gmail.com>
X-Google-Sender-Auth: 6776a6f0131ecdbd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, kernel coder <lhrkernelcoder@gmail.com> wrote:
> hi,
>        I am recieveing the packet on eth1 and want to send it through eth2.
>
> I've written code in netif_recieve_skb function .This code changes the
> mac header in sk_buff structure so that it can be send through other
> interface card.But when i call ip_dev_find fucntion to get the second
> interface structure ,NULL is returned.I checked the ip of second
> ethernet card  and it was similar to one passed to ip_dev_find
> fucntion,then why NULL is being returned?
>

Um... why would you need to modify kernel code to do this?  Try "man route".

Lee
