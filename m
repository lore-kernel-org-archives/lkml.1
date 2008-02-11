Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbYBKWkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbYBKWkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYBKWkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:40:03 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755138AbYBKWkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:40:00 -0500
Date: Mon, 11 Feb 2008 14:38:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: jengelh@computergmbh.de, linux-kernel@vger.kernel.org, mingo@elte.hu,
       davej@redhat.com
Subject: Re: [PATCH] make /dev/kmem a config option
Message-Id: <20080211143804.76f9743f.akpm@linux-foundation.org>
In-Reply-To: <20080210170509.36999240@laptopd505.fenrus.org>
References: <20080210155534.17fc6e5e@laptopd505.fenrus.org>
	<Pine.LNX.4.64.0802110111160.7915@fbirervta.pbzchgretzou.qr>
	<20080210170509.36999240@laptopd505.fenrus.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008 17:05:09 -0800
Arjan van de Ven <arjan@infradead.org> wrote:

> Subject: [PATCH] make /dev/kmem a config option
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> This patch makes /dev/kmem a config option; /dev/kmem is VERY rarely
> used, and when used, it's generally for no good (rootkits tend to be
> the most common users). With this config option, users have the
> choice to disable /dev/kmem, saving some size as well.
> 
> A patch to disable /dev/kmem has been in the Fedora and RHEL kernels for
> 4+ years now without any known problems or legit users of /dev/kmem.
> 

I question the testedness of this.

> +config DEV_KMEM
> ...
> +#ifdef CONFIG_DEVKMEM
>

