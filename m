Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbYGMI2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbYGMI2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 04:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYGMI20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 04:28:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085AbYGMI20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 04:28:26 -0400
Date: Sun, 13 Jul 2008 01:28:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jakub W. Jozwicki" <jozwicki@aster.pl>
Cc: linux-kernel@vger.kernel.org, mgross@linux.intel.com
Subject: Re: [PATCH 2.6.25.10] pm_qos_params: change spinlock to rwlock
Message-Id: <20080713012816.8c136efa.akpm@linux-foundation.org>
In-Reply-To: <200807130119.19663.jozwicki@aster.pl>
References: <200807130119.19663.jozwicki@aster.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008 01:19:19 +0200 "Jakub W. Jozwicki" <jozwicki@aster.pl> wrote:

> Concurrent calls to pm_qos_requirement shouldn't block each other. This patch 
> changes spinlock to rwlock and fixes issues with PREEMPT_RT.

"fixes issues" is nowhere near an adequate description.

Please provide complete descriptions for kernel patches.  That includes
describing the mysterious "issue" in full!

Thanks.


