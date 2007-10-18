Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbXJRDlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbXJRDlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 23:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759155AbXJRDlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 23:41:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41079 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759459AbXJRDln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 23:41:43 -0400
Date: Wed, 17 Oct 2007 20:41:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [Patch 002/002](memory hotplug) rearrange patch for notifier of
 memory hotplug
Message-Id: <20071017204128.99cad4b6.akpm@linux-foundation.org>
In-Reply-To: <20071018122210.514D.Y-GOTO@jp.fujitsu.com>
References: <20071018120343.5146.Y-GOTO@jp.fujitsu.com>
	<20071018122210.514D.Y-GOTO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 12:23:34 +0900 Yasunori Goto <y-goto@jp.fujitsu.com> wrote:

>  	writeback_set_ratelimit();
> +
> +	if (onlined_pages)
> +		memory_notify(MEM_ONLINE, &arg);

perhaps that open-coded writeback_set_ratelimit() should become a
notifier callback.
