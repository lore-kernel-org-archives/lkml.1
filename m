Return-Path: <linux-kernel-owner+w=401wt.eu-S1750774AbXBZPgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750774AbXBZPgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 10:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbXBZPgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 10:36:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:6066 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbXBZPgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 10:36:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MPh6COgU3C1gaPR/HmGrnSJxS+8VmYV8AEWWab9wnt02+j5ZSdB/s3e+7XfuCE5AvuVx+cpnPmYNV2TeLVvtTvqNbqdrcqNf6nvXURtX0B4y7I9DTcLjRnvuDpOCyY/q7fOnXQq/7x08uVA9nOvC+HPkYaQ4Z+u8gHGMwoxOyNo=
Message-ID: <f19298770702260736i51622584r1979a202bdc64c1d@mail.gmail.com>
Date: Mon, 26 Feb 2007 18:36:05 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: ioread32 endianess.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

May I ask you, guys, if ioread32 and his friends should treat the data
as host-endian or bus-endian? E.g, should the data read from PCI on a
big-endian host be byte swapped or not?
