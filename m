Return-Path: <linux-kernel-owner+w=401wt.eu-S1764070AbXGJJY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764070AbXGJJY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762124AbXGJJYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:24:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:11411 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761466AbXGJJYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:24:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VIvUq4mq6EYo+ccWs7U/hqn4PZ9tXE7NX1nb/t67BQd3Z4Z6BY83dkJspRVRTpwrwtnRKZbMZeTbi3GDZMo59/e0Ycs58QCFhjPDvAW4WnVtY9QEGrlavb57KONMgLR2qdnYhBod7I6Bd1DXiSN0NhLFzaJ0P5YqkfFRRgOdqVs=
Message-ID: <a9e22dff0707100223y5676ca63h7aaab05a660ed81d@mail.gmail.com>
Date: Tue, 10 Jul 2007 12:23:59 +0300
From: "Ni@m" <niam.niam@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: vmware modules with 2.6.22
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! I have  problem building vmware modules with 2.6.22.
During code investigation I've notiesd that vmware modules are using
old sk_buff structure

/////
skb->h.raw != skb->nh.raw
/////

how can I modify code to be able to compile it and where can I read
migration guide for sk_buff?

Thanks!

Milinevsky Dmitriy
