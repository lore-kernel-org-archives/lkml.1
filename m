Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbZACAEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbZACAEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 19:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759511AbZACAEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 19:04:04 -0500
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:59361 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759388AbZACAEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 19:04:01 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] [DMAR] Fix endless "Unknown DMAR structure type" loop
To: Avi Kivity <avi@redhat.com>, Tony Battersby <tonyb@cybernetics.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Reply-To: 7eggert@gmx.de
Date: Sat, 03 Jan 2009 01:03:54 +0100
References: <bOPDK-1i9-1@gated-at.bofh.it> <bOPNs-1u4-5@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LItze-0001ij-Nx@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> wrote:

> (copying relevant people)
> 
> Tony Battersby wrote:

>> +                            "Invalid 0-length structure\n");

This line is everything the reader of your message will see, (unless it happens
not to be the first ACPI error). I would not be able to tell the cause without
grepping the kernel source.

