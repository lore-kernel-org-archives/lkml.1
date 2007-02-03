Return-Path: <linux-kernel-owner+w=401wt.eu-S1751731AbXBCVWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbXBCVWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 16:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbXBCVWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 16:22:19 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:46136 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbXBCVWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 16:22:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=o2vjTYMxY4p4UrhcNqfrHlf53n9THXA3aPfHAkR+4JC2OkNu+Osz0RGgbNNrXj6PQ5CGyTus/Usc0Smcab40oNJMF6vrMaXomlhhfU8C8L8F/F8eggGP7BGiGkgec9p6iHKxHfl8TsDnkrPis4QG9s0uI7x4L2g7cmmMvxy31pE=
Message-ID: <75b66ecd0702031322k58db9da7l1ae1fc3a9342682b@mail.gmail.com>
Date: Sat, 3 Feb 2007 16:22:17 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: ebuddington@wesleyan.edu
Subject: Re: 2.6.20-rc6-mm3 BUG in drm_ioctl with Rage 128 card
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070203185407.GA5256@pool-70-109-243-148.wma.east.verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070203185407.GA5256@pool-70-109-243-148.wma.east.verizon.net>
X-Google-Sender-Auth: c362559fb3291463
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/3/07, Eric Buddington <ebuddington@verizon.net> wrote:
> EIP:    0060:[<00000000>]    Tainted: G   M   VLI
> EFLAGS: 00013246   (2.6.20-rc6-mm3 #1)

The "M" taint flag indicates that a machine check exception has
occured.  Check your logs for the MCE and make sure the hardware is
OK.

Lee
