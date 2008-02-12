Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbYBLFBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbYBLFBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 00:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYBLFB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 00:01:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59189 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbYBLFB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 00:01:27 -0500
Date: Mon, 11 Feb 2008 20:59:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: jengelh@computergmbh.de, linux-kernel@vger.kernel.org, mingo@elte.hu,
       davej@redhat.com
Subject: Re: [PATCH] make /dev/kmem a config option
Message-Id: <20080211205914.f357d179.akpm@linux-foundation.org>
In-Reply-To: <20080211200329.2b272759@laptopd505.fenrus.org>
References: <20080210155534.17fc6e5e@laptopd505.fenrus.org>
	<Pine.LNX.4.64.0802110111160.7915@fbirervta.pbzchgretzou.qr>
	<20080210170509.36999240@laptopd505.fenrus.org>
	<20080211143804.76f9743f.akpm@linux-foundation.org>
	<20080211200329.2b272759@laptopd505.fenrus.org>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 20:03:29 -0800 Arjan van de Ven <arjan@infradead.org> wrote:

> +config DEVKMEM
> +	bool "/dev/kmem virtual device support"
> +	help
> +	  Say Y here if you want to support the /dev/kmem device. The
> +	  /dev/kmem device is rarely used, but can be used for certain
> +	  kind of kernel debugging operations.
> +	  When in doubt, say "N".

I think this should be `default y'.  So that we don't cause /dev/kmem to
magically disappear for `make oldconfig' users.
