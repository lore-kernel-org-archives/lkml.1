Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab0CBCBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 21:01:11 -0500
Received: from mail-pz0-f179.google.com ([209.85.222.179]:49086 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab0CBCBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 21:01:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=sOCvS0KeBYrZHVxrQ4nTDbytkeuKmvCmlGSroq8qmUSaQVvseh7YwaKigv2TIp1Ho/
         H+FeyuywAsgGi0lVdktZLTgqCTX7MW2ZCQ9d3YmtSPQK+hzuimuNfhbGRBiSKRRwejDH
         QSCzN2gAV1HDsYATTLFyZIJqEB2O10nL/InnE=
MIME-Version: 1.0
Date: Mon, 1 Mar 2010 18:01:08 -0800
Message-ID: <cf70f0211003011801r33027ec8s78c9326f9d058c46@mail.gmail.com>
Subject: Disadvantage of using yaffs checkpointing ?
From: Shivdas Gujare <shivdas.tech@gmail.com>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am very new to mtd & yaffs and working on boottime optimization and
found that yaffs checkpointing helps to mount
yaffs2 very quickly. I tried it, and was able to save almost 4sec for
128MB partitioned nand.

Since everything looks very good If I use yaffs checkpointing feature
but have a doubt, are there any disadvantage of using check-pointing
by default in final product?

I understood that, check-pointing only disables boot time nand block
scanning & marking it bad if found,
and takes "system snapshot" while using "umount /dev/mtdblockN" which
it use in next boot.
So, If I decided to use "checkpointing" with "umount" while powering
off the device in final product,
are there going to be any problems I will face avoiding block scanning?

Thanks lot for any help.

Thanks and Regards,
Shivdas Gujare
