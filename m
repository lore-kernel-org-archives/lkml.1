Return-Path: <linux-kernel-owner+w=401wt.eu-S1760413AbZA3AKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413AbZA3AKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbZA3AK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:10:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759192AbZA3AKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:10:24 -0500
Date: Thu, 29 Jan 2009 16:09:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "James Kirin" <james.kirin40@gmail.com>
Cc: yinghai@kernel.org, rdreier@cisco.com, linux-kernel@vger.kernel.org
Subject: Re: kernel panic when using disable_mtrr_trim [was: Re: memory
 beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y]
Message-Id: <20090129160943.1bb0d3b5.akpm@linux-foundation.org>
In-Reply-To: <baeb34bc0901201018s5c6eaedcp9ba0dc7e81642509@mail.gmail.com>
References: <baeb34bc0901201018s5c6eaedcp9ba0dc7e81642509@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2009 13:18:15 -0500
"James Kirin" <james.kirin40@gmail.com> wrote:

> Hi Yinghai,
> 
> When I boot with "disable_mtrr_trim mem=4g", the system boots fine.
> Then I changed that to
> "disable_mtrr_trim mem=6g" and a kernel panic occurs:
> 
> [...] Freeing unused kernel memory: 296k freed
> [...]  Write protecting the kernel text: 3040k
> [...]  Write protecting the kernel read-only data: 1352k
> [...]  khelper used greatest stack depth: 6724 byytes left
> [...]  Kernel panic - not syncing: No init found. Try passing init=
> option to kernel.
> 
> I can always reproduce this: all it takes it to boot from a rescue CD,
> switch between "mem=4g"  and "mem=6g" in /etc/lilo.conf, run lilo and
> reboot. If it is 4g, it boots fine; if it is 6g, a kernel panic
> occurs. No other changes at all were made.
> 
> Same thing (kernel panic) occurs if mem=5g is used.
> 
> I am attaching the kernel config used when this happens.
> 
> Please let me know how I can help fix this. Does it somehow depend on
> all those MTRR/etc memory-related options in the kernel configuration?
> 

Did this get fixed?

Which kernel versions are affected?

Thanks.
