Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbXK0UiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbXK0UiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 15:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbXK0UiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 15:38:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:25430 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbXK0UiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 15:38:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PLmsOmZLB4iVNLlZkDcn3WnbpKUycl5UvQBvvRPb4/2eSAa3CiycOADmMMPCckizzZbc0BuQSBmkYgein7WsnwLSVAWJzl9jUeth6mHKfPKPFfiuBVn4eQmo0GpUVOLJH5qlHALKsusfDSeD1rKdBHsaHY7HHyUSz4wtBvQwNQI=
Message-ID: <d15adc960711271238g73fcf3bdv8f67cbcd54382991@mail.gmail.com>
Date: Tue, 27 Nov 2007 12:38:04 -0800
From: "Saswat Praharaj" <saswat@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question on splice
Cc: saswat@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I am a linux application programmer and kernel newbie.

I would like to use splice() / tee() to do some packet forwarding.
I think these two systems calls are there in 2.6.18 kernel.

My company is deciding to use either 2.6.21 or 2.6.22 kernel in our product.

My question is : Is splice() stable in 2.6.21 / 2.6.22 ?

I found this link where it says

 http://lwn.net/Articles/251707/ (search splice)

Jens Axboe (2):
 splice: fix direct splice error handling
 Fix race with shared tag queue maps


Looks like there were some issues with splice that has been fixed in
2.6.22.9 kernel.

I am not sure how critical is that problem . Can I still use the
2.6.21/2.6.22 kernel for splice without any major issues ?
If not, which kernel version would give me a stable splice() .

Please note that I am not subscribed to this list , so please CC me (a
reply-all would do) in your reply.


Thanks in advance.

-Saswat
