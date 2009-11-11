Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbZKKVfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbZKKVfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759228AbZKKVfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:35:21 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51782 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758823AbZKKVfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:35:20 -0500
Message-ID: <4AFB2E17.6060000@garzik.org>
Date: Wed, 11 Nov 2009 16:35:19 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH RFC] x86: fix confusing name of /proc/cpuinfo "ht" flag
References: <200911112134.34261.bzolnier@gmail.com>
In-Reply-To: <200911112134.34261.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 03:34 PM, Bartlomiej Zolnierkiewicz wrote:
>
> "ht" flag indicates only ability to detect siblings not HT presence itself.
>
> Inspired by:
> http://www.codemonkey.org.uk/2009/11/10/common-hyperthreading-misconception/
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
> It could be that there are some user-space programs depending on "ht"
> flag so the patch is marked as RFC..

I think that is the only problem with this patch -- it is an ABI change. 
  See as it's been this way for years, a comment is probably the best 
you can do...

	Jeff




