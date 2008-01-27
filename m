Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYA0HF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYA0HF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 02:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYA0HFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 02:05:50 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:21735 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYA0HFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 02:05:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=AggryWu452fSEfUsMmXbKZZ9gQfdQPL/+o8EMXxVOE9/S0l85+SSX+Fdl+UMAi/Vp3mts2fP8chAzbnVlinSLBxeb//rXjvTt9rmnDPrKoI6klRZeWcwIBcOlFgjlybp86vsqXwAdPMdPPrJhBu/2kJaGQf9W9UteL8J9mlY88c=
Message-ID: <2f11576a0801262305r461e0b16s572ba224bc4cde4@mail.gmail.com>
Date: Sun, 27 Jan 2008 16:05:47 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] [14/18] BKL-removal: Add unlocked_fasync
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@osdl.org,
       kosaki.motohiro@gmail.com
In-Reply-To: <20080127021721.08AEA14D2E@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080127317.043953000@suse.de>
	 <20080127021721.08AEA14D2E@wotan.suse.de>
X-Google-Sender-Auth: bff48064b0f0764b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add a new fops entry point to allow fasync without BKL. While it's arguably
> unclear this entry point is called often enough for it really matters
> it was still relatively easy to do. And there are far less async users
> in the tree than ioctls so it's likely they can be all converted
> eventually and then the non unlocked async entry point could be dropped.

Excellent!
I like this patch :)
