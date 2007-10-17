Return-Path: <linux-kernel-owner+w=401wt.eu-S933739AbXJQNTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739AbXJQNTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761434AbXJQNTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:19:11 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:36360 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760412AbXJQNTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:19:10 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [PATCH] clear PF_VCPU in kvm_guest_exit()
Date: Wed, 17 Oct 2007 15:18:28 +0200
User-Agent: KMail/1.9.7
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, avi@qumranet.com
References: <47135D1B.1060004@bull.net> <11926264852739-git-send-email-Laurent.Vivier@bull.net>
In-Reply-To: <11926264852739-git-send-email-Laurent.Vivier@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710171518.28552.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 17. Oktober 2007 schrieb Laurent Vivier:
> clear PF_VCPU in kvm_guest_exit() and move kvm_guest_exit() after 
> local_irq_enable().

Looks good. In the next days I will sent a patch for precise guest time 
accounting with CONFIG_VIRT_CPU_ACCOUNTING on top of this patch. 

Acked-By: Christian Borntraeger <borntraeger@de.ibm.com>
