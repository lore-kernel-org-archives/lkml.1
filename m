Return-Path: <linux-kernel-owner+w=401wt.eu-S2993065AbXCIHfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993065AbXCIHfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993068AbXCIHfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:35:38 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58058 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993065AbXCIHfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:35:37 -0500
Date: Fri, 9 Mar 2007 08:35:12 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, mbligh@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix avr32 TIF atomicity in do_debug_priv
Message-ID: <20070309083512.06e67846@dhcp-252-105.norway.atmel.com>
In-Reply-To: <20070309032137.GD9462@Krystal>
References: <20070309032137.GD9462@Krystal>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007 22:21:37 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Fix avr32 TIF atomicity in do_debug_priv
> 
> avr32 updates the thread flags 1 - non atomically and 2 - with the wrong value
> (for TIF_SINGLE_STEP) in this function.
> 
> It applies to 2.6.20.

Thanks, but this has already been fixed by a19b4a14053f for 2.6.21.

Haavard
