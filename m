Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbZKMWeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbZKMWeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbZKMWeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:34:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756682AbZKMWeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:34:18 -0500
Date: Fri, 13 Nov 2009 14:34:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, bcrl@kvack.org,
       Jeff Moyer <jmoyer@redhat.com>, Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH]aio: remove unused field
Message-Id: <20091113143408.c7965e74.akpm@linux-foundation.org>
In-Reply-To: <20091112075247.GA17960@sli10-desk.sh.intel.com>
References: <20091112075247.GA17960@sli10-desk.sh.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 15:52:47 +0800
Shaohua Li <shaohua.li@intel.com> wrote:

> Don't know the reason, but it appears ki_wait field of iocb never gets used.

If we do this then kick_iocb() has only one in-kernel caller, in
drivers/usb/gadget/inode.c.  I wonder if the gadget code really needs
to be using kick_iocb()?

