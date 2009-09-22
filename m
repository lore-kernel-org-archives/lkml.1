Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbZIVSIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbZIVSIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbZIVSId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:08:33 -0400
Received: from mail.perches.com ([173.55.12.10]:1097 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533AbZIVSIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:08:32 -0400
Subject: Re: [PATCH 03/21] ceph: client types
From: Joe Perches <joe@perches.com>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, yehuda@newdream.net
In-Reply-To: <1253641129-28434-4-git-send-email-sage@newdream.net>
References: <1253641129-28434-1-git-send-email-sage@newdream.net>
	 <1253641129-28434-2-git-send-email-sage@newdream.net>
	 <1253641129-28434-3-git-send-email-sage@newdream.net>
	 <1253641129-28434-4-git-send-email-sage@newdream.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Sep 2009 11:08:35 -0700
Message-Id: <1253642915.30020.63.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 10:38 -0700, Sage Weil wrote:
> diff --git a/fs/ceph/ceph_debug.h b/fs/ceph/ceph_debug.h
> new file mode 100644
> index 0000000..be9b8bc
> --- /dev/null
> +++ b/fs/ceph/ceph_debug.h
> +# if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
> +extern const char *ceph_file_part(const char *s, int len);
> +#  define dout(fmt, ...)						\
> +	pr_debug(" %12.12s:%-4d : " fmt,				\
> +		 ceph_file_part(__FILE__, sizeof(__FILE__)),		\
> +		 __LINE__, ##__VA_ARGS__)

perhaps:

#define pr_fmt(fmt) "%s:%d" fmt, __FILE__, __LINE__


