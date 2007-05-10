Return-Path: <linux-kernel-owner+w=401wt.eu-S1761728AbXEJOXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761728AbXEJOXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXEJOXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:23:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:46001 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbXEJOXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:23:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=s3gKHUQFEibm+knsUJyYxO9wujiDFeaI+R9KtQG9Pcb6RYNBX/AWWcO9Knm9INilDc4md+pAzyIRNhCDN4VKbS+fWfcsrCRpRLNoO998Dl09MebzJrCKgtJZY5VtnnnoVkKpfYlYaHoiQOlXuI0sotAAZI+fpG/ZN/dwz44++lM=
Message-ID: <76391b770705100723w24c93b99m48180a759d2116c7@mail.gmail.com>
Date: Thu, 10 May 2007 22:23:32 +0800
From: "liang yuanen" <linux.kernel.liang@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: why are we reduce spin-lock and replace it with lock-free?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Three are many many spin-lock in the kernel code, and in multi-core
conditions, it push down the kernel performance.why are we reduce
spin-lock and replace it with lock-free?
