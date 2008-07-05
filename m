Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbYGEL6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbYGEL6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYGEL5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:57:36 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:24455 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbYGEL5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:57:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=mrIBXJ02TaFT4pTvy2G48YuJl03zXqvFfm1+WoZkOmqRx9/UvKwFUHUiXOp8kCyHAl
         0JnBIc3p+T7qJJx/GCHaWCJsLkc1DnSN3ccq7Jxz2k532WgdWKqyuKh7jSCicSnc8+7I
         pU1ayuOq3PXZ+zErbYiGbjQr2LKKDG/uCvg0I=
User-Agent: quilt/0.46-1
Date: Sat, 05 Jul 2008 15:53:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, akpm@linux-foundation.org, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/5] early params NULL pointer deref fix
Message-ID: <486f61a9.1e35440a.5815.ffffbc7d@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This series fix a possible NULL pointer deref in case if user
was stupid enough to pass boot parameter without a mandatory value

 Actually there is a number of such issues on other platforms too
(like powerpc, sh, s390) so I think it should be fixed too (any
volunteers?)

 Any comments are welcome.

		- Cyrill -
-- 
