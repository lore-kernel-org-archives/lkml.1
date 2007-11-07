Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbXKGNKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbXKGNKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbXKGNKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:10:18 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:56789 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757484AbXKGNKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:10:16 -0500
Date: Wed, 7 Nov 2007 14:09:53 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 4/4] Move Kconfig.instrumentation to arch/Kconfig and
 init/Kconfig
Message-ID: <20071107140953.6b2cb1fa@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20071106204152.754044476@polymtl.ca>
References: <20071106203724.620893371@polymtl.ca>
	<20071106204152.754044476@polymtl.ca>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Nov 2007 15:37:28 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Index: linux-2.6-lttng/init/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/init/Kconfig	2007-11-02 13:16:41.000000000 -0400
> +++ linux-2.6-lttng/init/Kconfig	2007-11-02 13:16:55.000000000 -0400
> @@ -644,6 +644,20 @@ config SLOB

> +source "ltt/Kconfig"

This one seems to be new, and I can't seem to find ltt/Kconfig
anywhere. Wouldn't it be better to move it to a separate patch?

Håvard
