Return-Path: <linux-kernel-owner+w=401wt.eu-S932124Ab0AFGgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab0AFGgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 01:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096Ab0AFGgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 01:36:35 -0500
Received: from ozlabs.org ([203.10.76.45]:52702 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086Ab0AFGgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 01:36:32 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anton Blanchard <anton@samba.org>
Subject: Re: [patch 6/6] x86: cpumask_of_node() should handle -1 as a node
Date: Wed, 6 Jan 2010 17:06:26 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
References: <20100106045509.245662398@samba.org> <20100106045509.245662398@samba.org>> <20100106045525.476396870@samba.org>>
In-Reply-To: <20100106045525.476396870@samba.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001061706.26845.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010 03:25:15 pm Anton Blanchard wrote:
> pcibus_to_node can return -1 if we cannot determine which node a pci bus
> is on. If passed -1, cpumask_of_node will negatively index the lookup array
> and pull in random data:

If you grep for the callers, you'll see those which do this (now-obsolete)
check.  One more patch :)

Thanks,
Rusty.
