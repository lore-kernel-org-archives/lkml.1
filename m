Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYIYPZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYIYPZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYIYPZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 11:25:42 -0400
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:46239 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645AbYIYPZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 11:25:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=KNFa3kqctfNRvC0dvsyFZlTWzLRj8paKBy30tucyOKDSY395H455qKdxEpOQv9Aa;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <48DBAD73.3000202@earthlink.net>
Date: Thu, 25 Sep 2008 11:25:39 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.26.5 hangs on boot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79b26a5fcac37c7515b97ddd49923985d9350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.118.36.229
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Vanilla kernel 2.6.26.5 hangs on boot right after displaying
isapnp: Scanning For PnP cards ...
isapnp: No Plug & Play device found

I have to power off my laptop to get out of this state. I never had this problem 
with previous kernels.

Redhat Bugzilla has other people with this problem. I had it too so I compiled
a vanilla kernel to make sure it wasn't vendor specific.
https://bugzilla.redhat.com/show_bug.cgi?id=462156

If I append clocksource=hpet then the kernel will boot - but I shouldn't have to 
do this.

My laptop is an asus z96f with a core 2 duo processor.

Steve

