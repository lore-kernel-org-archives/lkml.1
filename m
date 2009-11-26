Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbZKZDNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbZKZDNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 22:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZKZDNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 22:13:00 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:39800 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbZKZDNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 22:13:00 -0500
Message-ID: <4B0DF23A.2080207@garzik.org>
Date: Wed, 25 Nov 2009 22:12:58 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ian Molton <ian.molton@collabora.co.uk>
CC: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, mpm@selenic.com
Subject: Re: [PATCH 1/2] hw_random: core updates to allow more efficient drivers
References: <1259177252.2858.17.camel@calx> <1259195127-20086-1-git-send-email-ian.molton@collabora.co.uk> <1259195127-20086-2-git-send-email-ian.molton@collabora.co.uk>
In-Reply-To: <1259195127-20086-2-git-send-email-ian.molton@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2009 07:25 PM, Ian Molton wrote:
> 	This patch implements a new method by which hw_random hardware drivers
> can pass data to the core more efficiently, using a shared buffer.
>
> The old methods have been retained as a compatability layer until all the
> drivers have been updated.
>
> Signed-off-by: Ian Molton<ian.molton@collabora.co.uk>
> ---
>   drivers/char/hw_random/core.c |  120 ++++++++++++++++++++++++++---------------
>   include/linux/hw_random.h     |    9 ++-
>   2 files changed, 82 insertions(+), 47 deletions(-)

Speaking as the original hw_random author...  very nice!  We have needed 
a more efficient API for years.

	Jeff


