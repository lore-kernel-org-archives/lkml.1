Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbYLTNNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbYLTNNP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 08:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYLTNNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 08:13:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:11603 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYLTNND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 08:13:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rLLILxs1d0pDj8x9VcRrBQlWqK/ftyUrNXd7utWJ8Ozywond3NAvKIzw0MGRvknKLr
         vOWLeZnhvvO7HyxKhnTF3CtxrI2qehCsXeSllpFrSN2j3zP0UZHP3RVyYSV3ac5rZJO4
         9QZWXS6BCeh1gD96mTi+0BurhL5BBN3qFBgtQ=
Message-ID: <b82a89170812200513q1a27b62ap590fb6fbad930a@mail.gmail.com>
Date: Sat, 20 Dec 2008 18:43:01 +0530
From: "Niraj kumar" <niraj17@gmail.com>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: [Question] inotify : process based filtering of events
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
In-Reply-To: <20081220104048.GB23632@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b82a89170812192251u3544f087x94775b6864f5ae8d@mail.gmail.com>
	 <20081220104048.GB23632@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Is it possible to achieve this process based filtering of events
>> using inotify infrastructure?
>
> You can try using inotify nested attributes patch [1] and filter events
> in userspace based on reported pid/tid.

I saw your patch and the related discussion...
But I am thinking that filtering in userspace based on pid/tid
could be too much overhead when the data that I am interested
in might be just a small fraction of the whole thing...

I was hoping to add a flag (similar to IN_ATTRS that you have added)
which, when used, will only collect events for the calling
process and it's children...

-Niraj
