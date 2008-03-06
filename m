Return-Path: <linux-kernel-owner+w=401wt.eu-S934168AbYCFBXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934168AbYCFBXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 20:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763993AbYCFBSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 20:18:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933106AbYCFBSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 20:18:40 -0500
Date: Wed, 5 Mar 2008 17:13:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: linux-kernel@vger.kernel.org, menage@google.com, sukadev@us.ibm.com,
       serue@us.ibm.com
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
Message-Id: <20080305171304.f686f6de.akpm@linux-foundation.org>
In-Reply-To: <47CEDA64.1070506@openvz.org>
References: <47CED717.60406@openvz.org>
	<47CEDA64.1070506@openvz.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2008 20:37:40 +0300
Pavel Emelyanov <xemul@openvz.org> wrote:

> diff --git a/include/linux/devscontrol.h b/include/linux/devscontrol.h
> new file mode 100644
> index 0000000..04c168b
> --- /dev/null
> +++ b/include/linux/devscontrol.h
> @@ -0,0 +1,12 @@
> +#ifndef __DEVS_CONTROL_H__
> +#define __DEVS_CONTROL_H__
> +static inline struct kobj_map *task_cdev_map(struct task_struct *tsk)
> +{
> +	return NULL;
> +}
> +
> +static inline struct kobj_map *task_bdev_map(struct task_struct *tsk)
> +{
> +	return NULL;
> +}
> +#endif

This doesn't include sufficient headers to be compileable.

I'm sure there are lots of headers like this.  But we regularly need
to fix them.
