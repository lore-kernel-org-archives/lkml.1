Return-Path: <linux-kernel-owner+w=401wt.eu-S1762435AbYJJPDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762435AbYJJPDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761367AbYJJPA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:00:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:18612 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761822AbYJJPAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=FrqOTKZoXeVbYtswlSzEQkSn3UcJbht3oLzm/qhqDn6XcmRQKSWNgiUsSFLgPBmG6b
         G26DzbC7Vyj3mmF/SNo+7Te0A9sNqGdndumZYmcSd/+SBdbalQinYc8SEqjMPVSlTUTm
         MAt+B4LV7kCsq6hXKc31mED32d6Peze0BHdKU=
Message-ID: <92034aa00810100800v228870f3sddb1015acf9f064d@mail.gmail.com>
Date: Fri, 10 Oct 2008 12:00:54 -0300
From: "Joilnen Leite" <joilnen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel_physical_mapping_init
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wondering if inside  kernel_physical_mapping_init func would be better
---
    if (pfn >= end_pfn)
         continue;
    pmd = one_md_table_init(pgd);
---
in first for statment


Joilnen
