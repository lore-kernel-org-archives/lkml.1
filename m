Return-Path: <linux-kernel-owner+w=401wt.eu-S1765611AbYEHSWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765611AbYEHSWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYEHSWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:22:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbYEHSWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:22:44 -0400
Date: Thu, 8 May 2008 14:11:26 -0400
From: Rik van Riel <riel@redhat.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: Re: [PATCH 8/9] Call idr_find() without locking in ipc_lock()
Message-ID: <20080508141126.7546649d@bree.surriel.com>
In-Reply-To: <20080507113737.964082000@bull.net>
References: <20080507113553.395937000@bull.net>
	<20080507113737.964082000@bull.net>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 13:36:01 +0200
Nadia.Derbey@bull.net wrote:

> [PATCH 08/09]
> 
> This patch makes idr_find() called locklessly in ipc_lock(), since the idr
> tree is now RCU protected.
> 
> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
