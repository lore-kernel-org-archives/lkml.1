Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYCYKcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYCYKcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 06:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbYCYKcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 06:32:10 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:34280 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbYCYKcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:32:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=CzKvrF6yGWJNkaoDBNwVaDx5M3uD3wTbxTHA92DqlX48POTs+ZO/AwLb6FfbIBY5tom0SazL4MMs1decwzUtTwBqKxscZ5qoU21+4UUaOm0b6zJplrDW5pBUCJ/J3D9LvGdJIMFztaVHG9Y6hH3xJTlTL4jLTUjA844UF4H1qK4=
Message-ID: <47E8D5C7.4020600@gmail.com>
Date: Tue, 25 Mar 2008 06:36:55 -0400
From: Scott Lovenberg <scott.lovenberg@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Shard Gupta <shard.kgp@gmail.com>
CC: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Subject: Re: Allocating memory in the form of 'BITS'
References: <983191750803250323k2e944fe0y53e4c0d69edde3b@mail.gmail.com>
In-Reply-To: <983191750803250323k2e944fe0y53e4c0d69edde3b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shard Gupta wrote:
> Hello List,
>
> I am writing a linux kernel module, and I want to allocates the memory
> in a way so I can define each individual bit, like bitfield structure
> in userspace.
> Please tell me the way to do the same.
>
> Thanks and regards,
>
> Shard Gupta
>
> --
> To unsubscribe from this list: send an email with
> "unsubscribe kernelnewbies" to ecartis@nl.linux.org
> Please read the FAQ at http://kernelnewbies.org/FAQ
>
>
>   
If you want to set every bit to zero, you could use calloc(); otherwise, 
I think you'll need to use a bitmask and "<<", ">>" (bit shift left, 
right).  You could also probably do a bitwise '&' and '|'.
