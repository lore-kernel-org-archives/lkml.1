Return-Path: <linux-kernel-owner+w=401wt.eu-S1763854AbYEHSOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763854AbYEHSOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYEHSOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:14:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbYEHSOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:14:16 -0400
Date: Thu, 8 May 2008 14:13:17 -0400
From: Rik van Riel <riel@redhat.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: Re: [PATCH 9/9] Get rid of ipc_lock_down()
Message-ID: <20080508141317.71b33396@bree.surriel.com>
In-Reply-To: <20080507113738.379341000@bull.net>
References: <20080507113553.395937000@bull.net>
	<20080507113738.379341000@bull.net>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 13:36:02 +0200
Nadia.Derbey@bull.net wrote:

> [PATCH 09/09]
> 
> This patch removes the ipc_lock_down() routines: they used to call idr_find()
> locklessly (given that the ipc ids lock was already held), so they are not
> needed anymore.
> 
> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
