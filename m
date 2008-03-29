Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYC2RDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYC2RDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbYC2RDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:03:06 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:31208 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbYC2RDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:03:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=HkUjOOojUgChDw1h1hw7diFXdWqw6Y4GxmpBxqqSiBC1UFT4uxq/r3CkQf21EDY0jtItEkyaQoep0ZJMSehZGufN+fcCvfj0uPT9/JuvpcngIfMObwI3uMDckDQqGG5W1UJ7So5VC6Er2Fg15ZLtWpCyr2MCT1OLUqJZsWBxMQQ=
Message-ID: <47EE75A0.8070705@gmail.com>
Date: Sat, 29 Mar 2008 18:00:16 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Comma at end of enum lists
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I've found that in many enum lists, there's a comma at the end, e.g. 
(arch/x86/kernel/early_printk.c):

enum {
         MAGIC1 = 0xBACCD00A,
         MAGIC2 = 0xCA110000,
         XOPEN = 5,
         XWRITE = 4,
};

Just out of curiosity, is there any particular reason here (no word in 
CodingStyle about that).

-Jacek
