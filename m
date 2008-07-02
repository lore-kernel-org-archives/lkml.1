Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYGBKoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYGBKoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 06:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYGBKo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 06:44:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751234AbYGBKo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 06:44:26 -0400
Date: Wed, 2 Jul 2008 03:41:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, amit.shah@qumranet.com, muli@il.ibm.com,
       alexisb@us.ibm.com, andi@firstfloor.org,
       kvm-devel@lists.sourceforge.net, avi@qumranet.com
Subject: Re: [PATCH v2 -mm 1/2] add the device argument to dma_mapping_error
Message-Id: <20080702034147.b253eda0.akpm@linux-foundation.org>
In-Reply-To: <200807021220.44339.mb@bu3sch.de>
References: <1211178689-3507-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080702030723.dabf7546.akpm@linux-foundation.org>
	<200807021218.41153.mb@bu3sch.de>
	<200807021220.44339.mb@bu3sch.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 12:20:43 +0200 Michael Buesch <mb@bu3sch.de> wrote:

> 		return pci_dma_mapping_error(dev->bus->host_pci, addr);

that works, thanks.
