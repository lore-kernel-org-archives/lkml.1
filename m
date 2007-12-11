Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbXLKPTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbXLKPTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbXLKPTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:19:12 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:8548 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbXLKPTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:19:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=wJMfSS/+QhVcbW8Q5Qf1qdgRJhsFE5JjUI6gizZMbYEt8AzYvBhy2jR2u4LKYHjU8Y3sB6Grt9IQb+wUxCwzxP/8ulEtdbdqYgyYlhqXE2qHfx34dBwhnrujrM9FCuZl7Tpx028dNMW3n4kHD9ztwSBCR5VMDtPn7RE43T89nyk=
Date: Tue, 11 Dec 2007 18:18:59 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-input@atrey.karlin.mff.cuni.cz
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] handle EV_PWR in input_set_capability
Message-ID: <20071211151859.GA7965@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle EV_PWR type of input caps.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>

Index: linux-test/drivers/input/input.c
===================================================================
--- linux-test.orig/drivers/input/input.c	2007-12-11 17:47:37.736228749 +0300
+++ linux-test/drivers/input/input.c	2007-12-11 17:47:52.620224309 +0300
@@ -1080,6 +1080,10 @@ void input_set_capability(struct input_d
 		__set_bit(code, dev->ffbit);
 		break;
 
+	case EV_PWR:
+		/* do nothing */
+		break;
+
 	default:
 		printk(KERN_ERR
 			"input_set_capability: unknown type %u (code %u)\n",
