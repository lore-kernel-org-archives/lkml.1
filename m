Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752644AbYLRTvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbYLRTvI (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYLRTuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:50:50 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:7909 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbYLRTut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:50:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=cI6G3mfsoQeT5bC2qi9o6vtW22qu4CtG/iP+pLcg0mlbjcsWOiRFBOyi4Eb//efkc3
         h1+BH679vlNAkvmpFmXRNs9B6VNstqlva5NzetPw/+MJh5NoALFyuc+afzsnYqIJ/i7t
         j8TejJkZ8OVFzhz/JQQl4k2T9vwZDsyyKXB0k=
Message-ID: <3bedf6ab0812181150hb94e007gae8950b9b8a2c1a7@mail.gmail.com>
Date: Fri, 19 Dec 2008 01:20:48 +0530
From: "karthikeyan S" <karthispeaks@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: packets dropped after send returns success
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am facing an issue with a linux box (a wireless lan controller),
would like to have suggestions from you.
The controller sends a mobility udp ping request to it's mobility
members every 30 seconds upon receiving a ping request.
These ping responses are dropped randomly for unknown reasons (it runs
fine for 3-4 days then it experiences this problem for say 20 minutes
then resumes to normalcy)
This issue happens at the customer site and we haven't been able to
reproduce it in-house.

The mobility application sends the packet to the kernel using
sendmsg() and it returns success.What may be the possible reasons for
packets being dropped in kernel after sendmsg() returns success?
I don't think there are any routing issues. One possible reason that I
thought of is that the driver transmit queue is full.
But looks like other type of packets are going out of controller.
Could you plese provide your input? (kernel version is 2.4)

Thanks a lot.

-karthik
