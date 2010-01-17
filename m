Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407Ab0AQSZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab0AQSZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 13:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353Ab0AQSZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 13:25:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58396 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab0AQSZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 13:25:44 -0500
Date: Sun, 17 Jan 2010 18:25:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Emese Revfy <re.emese@gmail.com>
Cc: linux-kernel@vger.kernel.org, teigland@redhat.com, Matt_Domsch@dell.com,
       maciej.sosnowski@intel.com, hjk@linutronix.de,
       Pekka Enberg <penberg@cs.helsinki.fi>, jens.axboe@oracle.com,
       shemminger@vyatta.com, akpm@linux-foundation.org, davem@davemloft.net,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/1] Constify struct sysfs_ops for v2.6.33-rc4
Message-ID: <20100117182537.GQ19799@ZenIV.linux.org.uk>
References: <4B5338D6.2050209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5338D6.2050209@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 05:20:38PM +0100, Emese Revfy wrote:

> Signed-off-by: Emese Revfy <re.emese@gmail.com>
> Acked-by: David Teigland <teigland@redhat.com>
> Acked-by: Matt Domsch <Matt_Domsch@dell.com>
> Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
> Acked-by: Hans J. Koch <hjk@linutronix.de>
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Acked-by: Jens Axboe <jens.axboe@oracle.com>
> Acked-by: Stephen Hemminger <shemminger@vyatta.com>

NACKed-by: Al Viro <viro@zeniv.linux.org.uk>

Same reason.

> -        ssize_t (*show)(struct kobject *, struct attribute *, char *);
> -        ssize_t (*store)(struct kobject *, struct attribute *, const char *);
> +        ssize_t (* const show)(struct kobject *, struct attribute *, char *);
> +        ssize_t (* const store)(struct kobject *, struct attribute *, const char *);
