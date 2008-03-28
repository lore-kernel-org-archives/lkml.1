Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbYC1DRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbYC1DRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 23:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYC1DRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 23:17:42 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:56189 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752080AbYC1DRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 23:17:41 -0400
Message-ID: <47EC6353.1080602@steeleye.com>
Date: Thu, 27 Mar 2008 23:17:39 -0400
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@gmail.com>
CC: nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: nbd: Oops because nbd doesn't prevent NBD_CLEAR_SOCK while sock_xmit()
 is working on a receive
References: <170fa0d20803261143s1ab258b2ra470c158ac5744a@mail.gmail.com>	 <47EB94AB.6090608@steeleye.com>	 <170fa0d20803270621k7723ae47n337011beafe87cdb@mail.gmail.com> <170fa0d20803271412i6d7dd81ax41e0f77339b5def7@mail.gmail.com>
In-Reply-To: <170fa0d20803271412i6d7dd81ax41e0f77339b5def7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer wrote:

> With the nbd_sock_xmit_oops.patch applied this Oops no longer happens.
>  I think my original patch's use of EINVAL should be changed to EIO.
> Any other comments on the fix are welcome.

No, EINVAL is fine, so the original patch looks good to me.

> Paul, would you like an updated patch that you push upstream?  Or
> should I just submit the patch and Cc: you?

The original one is fine, go ahead and send it.

Thanks,
Paul
