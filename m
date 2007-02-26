Return-Path: <linux-kernel-owner+w=401wt.eu-S964843AbXBZJ7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843AbXBZJ7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 04:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964845AbXBZJ7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 04:59:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964843AbXBZJ7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 04:59:43 -0500
Subject: Re: [Cluster-devel] [2.6 patch] fs/dlm/user.c should #include
	"user.h"
From: Steven Whitehouse <swhiteho@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: pcaulfie@redhat.com, teigland@redhat.com, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070225231842.GD29575@stusta.de>
References: <20070225231842.GD29575@stusta.de>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 26 Feb 2007 10:13:28 +0000
Message-Id: <1172484808.11001.594.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now applied to the git tree. Thanks,

Steve.

On Mon, 2007-02-26 at 00:18 +0100, Adrian Bunk wrote:
> Every file should include the headers containing the prototypes for
> it's global functions.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> --- linux-2.6.20-mm2/fs/dlm/user.c.old	2007-02-25 19:40:16.000000000 +0100
> +++ linux-2.6.20-mm2/fs/dlm/user.c	2007-02-25 19:40:29.000000000 +0100
> @@ -22,6 +22,7 @@
>  #include "lockspace.h"
>  #include "lock.h"
>  #include "lvb_table.h"
> +#include "user.h"
>  
>  static const char *name_prefix="dlm";
>  static struct miscdevice ctl_device;
> 

