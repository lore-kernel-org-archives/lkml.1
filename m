Return-Path: <linux-kernel-owner+w=401wt.eu-S1757837AbXLLClh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbXLLClh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 21:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbXLLCl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 21:41:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48446 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752635AbXLLCl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 21:41:29 -0500
Date: Tue, 11 Dec 2007 18:40:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH -mm] x86 boot : export boot_params via sysfs
Message-Id: <20071211184012.a84fff36.akpm@linux-foundation.org>
In-Reply-To: <1197391749.17188.8.camel@caritas-dev.intel.com>
References: <1197391749.17188.8.camel@caritas-dev.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 16:49:09 +0000 "Huang, Ying" <ying.huang@intel.com> wrote:

> This patch export the boot parameters via sysfs. This can be used for
> debugging and kexec.
> 
> The files added are as follow:
> 
> /sys/kernel/boot_params/data	: binary file for struct boot_params
> /sys/kernel/boot_params/version	: boot protocol version

Your patch uses kobject_create_and_register() which was added in Greg's
driver tree as of 2.6.24-rc4-mm1.

However for some reason kobject_create_and_register() has magically vanished
from Greg's current driver tree so I cannot carry this patch, sorry.

