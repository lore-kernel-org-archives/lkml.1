Return-Path: <linux-kernel-owner+w=401wt.eu-S934437AbZKXXaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934437AbZKXXaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934420AbZKXXay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:30:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934419AbZKXXay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:30:54 -0500
Date: Tue, 24 Nov 2009 15:29:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 5/7] kfifo: add DEFINE_KFIFO and friends, add very tiny
 functions
Message-Id: <20091124152940.b515b8b3.akpm@linux-foundation.org>
In-Reply-To: <1258705633.4426.16.camel@wall-e>
References: <1258704942.4426.5.camel@wall-e>
	<1258705633.4426.16.camel@wall-e>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 09:27:13 +0100
Stefani Seibold <stefani@seibold.net> wrote:

>  Add DECLARE_KFIFO - macro to declare a kfifo and the associated buffer inside a struct
>  Add INIT_KFIFO - Initialize a kfifo declared by DECLARED_KFIFO
>  Add DEFINE_KFIFO - macro to define and initialize a kfifo as a global or local object
>  Add kfifo_size() - returns the size of the fifo in bytes
>  Add kfifo_is_empty() - returns true if the fifo is empty
>  Add kfifo_is_full() - returns true if the fifo is full
>  Add kfifo_avail() - returns the number of bytes available in the FIFO
>  Do some code cleanup

Causes this:


drivers/scsi/libiscsi_tcp.c: In function 'iscsi_tcp_cleanup_task':
drivers/scsi/libiscsi_tcp.c:449: warning: ignoring return value of 'kfifo_in', declared with attribute warn_unused_result
drivers/scsi/libiscsi_tcp.c:456: warning: ignoring return value of 'kfifo_in', declared with attribute warn_unused_result
drivers/scsi/libiscsi_tcp.c: In function 'iscsi_tcp_r2t_rsp':
drivers/scsi/libiscsi_tcp.c:557: warning: ignoring return value of 'kfifo_in', declared with attribute warn_unused_result
drivers/scsi/libiscsi_tcp.c:573: warning: ignoring return value of 'kfifo_in', declared with attribute warn_unused_result
drivers/scsi/libiscsi_tcp.c:583: warning: ignoring return value of 'kfifo_in', declared with attribute warn_unused_result
drivers/scsi/libiscsi_tcp.c: In function 'iscsi_tcp_get_curr_r2t':
drivers/scsi/libiscsi_tcp.c:985: warning: ignoring return value of 'kfifo_in', declared with attribute warn_unused_result
drivers/scsi/libiscsi_tcp.c:993: warning: ignoring return value of 'kfifo_out', declared with attribute warn_unused_result
