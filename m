Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbXKZICx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbXKZICx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 03:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbXKZICp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 03:02:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47027 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752842AbXKZICp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 03:02:45 -0500
Date: Mon, 26 Nov 2007 00:01:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert Richter" <robert.richter@amd.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Extended interrupt LVT support for AMD Barcelona
Message-Id: <20071126000145.fc4056bb.akpm@linux-foundation.org>
In-Reply-To: <20071120162511.E1EF28098@erda.amd.com>
References: <20071120162511.E1EF28098@erda.amd.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007 16:11:34 +0100 "Robert Richter" <robert.richter@amd.com> wrote:

> This patch adds extended interrupt support for AMD Barcelona CPUs. The
> patch provides functions to setup MCE and IBS interrupt
> vectors. Compared to the previous K8 implementation the vector offsets
> are centrally handled now in apic_64.c. Thus, the APIC setup code is
> responsible for vector mappings. The vector mapping is hardcoded for
> now.
> 
> Also macro definitions in apicdef.h has been updated.
> 

Please send a signed-off-by: for this work, as per Documentation/SubmittingPatches,
thanks.
