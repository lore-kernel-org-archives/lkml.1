Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZEGIFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZEGIFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZEGIEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:04:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:40290 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZEGIEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:04:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Tm4N0hULQbzQkGw1FNYvgJzAi0FvGeC2VcR6VquuN6H8NRPZtFpQccpNJ7/aSg9/If
         eEAfd+HlnJf0dalpGtaGe26YHz2RVdKcd5BHwjWbfbgxswPzwcxVU/++qkDOpqJ2Zev4
         b3LxQYDycIDcjWdRQ80LjOwsDKV/DTugExr/Y=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 7 May 2009 01:04:30 -0700
Message-ID: <43e72e890905070104u59eebcceu18718a733e388cc9@mail.gmail.com>
Subject: New kernel recommendations for ath9k
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For those not subscribed to the ath9k wiki on wireless.kernel.org [1]
(which we recommend you do if you're a user) here's a quick note to
let you know our latest kernel recommendations for using ath9k:

  *  >= 2.6.27.22
  *  >= 2.6.28.10
  *  2.6.29

If you want 802.11n support or AP support you'll want at least 2.6.29.
If you happen to have one of our new 1x1 AR9285 devices (all AR9285
devices are 1x1) then you'll need at least 2.6.29. If you want to
start using ath9k on APs with AHB you will need at least 2.6.30 (still
in RC series).

As usual if you happen to be stuck on older kernels for one reason or
another you can always use compat-wireless [2] and if that happens to
be a little too bleeding edge we have now compat-wireless releases for
stable kernel releases, starting as of the 2.6.30-rc series [3].

  Luis

[1] http://wireless.kernel.org/en/users/Drivers/ath9k
[2] http://wireless.kernel.org/en/users/Download
[3] http://wireless.kernel.org/en/users/Download/stable
