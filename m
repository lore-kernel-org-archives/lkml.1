Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbZBXGcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbZBXGcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 01:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZBXGcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 01:32:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51104 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbZBXGcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 01:32:46 -0500
Message-ID: <49A39489.3090202@zytor.com>
Date: Mon, 23 Feb 2009 22:32:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Parav Pandit <paravpandit@yahoo.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: virtually and physically (page) aligned allocation
References: <389971.28411.qm@web30104.mail.mud.yahoo.com>
In-Reply-To: <389971.28411.qm@web30104.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parav Pandit wrote:
> Hi,
> 
> Can user space application allocate memory which is virtually and physically aligned to the system's page boundary in the Linux 2.6.x?
> Such as using posix_memalign().
> 
> In other way,
> If user space application allocates memory which is aligned to page boundary for say 4 pages using posix_memalign(), will is ensure that it corresponds to exactly 4 physical pages in kernel which can be pinned down?
> 

You can use hugetlbfs to allocate a 2 MB page, otherwise no.

	-hpa

