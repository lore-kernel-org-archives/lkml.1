Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYIQV1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYIQV1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbYIQV1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:27:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911AbYIQV1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:27:35 -0400
Date: Wed, 17 Sep 2008 14:27:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: menage@google.com (Paul Menage)
Cc: balbir@linux.vnet.ibm.com, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix declaration of cgroup_mm_owner_callbacks
Message-Id: <20080917142714.a822ac1a.akpm@linux-foundation.org>
In-Reply-To: <20080915190638.99E613D6952@localhost>
References: <20080915190638.99E613D6952@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2008 12:06:38 -0700 (PDT)
menage@google.com (Paul Menage) wrote:

> Fix declaration of cgroup_mm_owner_callbacks()
> 
> The choice of real/dummy declaration for cgroup_mm_owner_callbacks()
> shouldn't be based on CONFIG_MM_OWNER, but on
> CONFIG_CGROUPS. Otherwise kernel/exit.c fails to compile when
> something other than a cgroups controller selects CONFIG_MM_OWNER
> 

Being too lazy to go back and find out what "something" is, I assumed
that this isn't needed in 2.6.27.
