Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbZK3MJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbZK3MJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZK3MJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:09:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40381 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbZK3MJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:09:16 -0500
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
In-Reply-To: <20091130120345.GA18879@linux.vnet.ibm.com>
References: <20091130120345.GA18879@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 13:09:12 +0100
Message-ID: <1259582952.20516.209.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 17:33 +0530, Srikar Dronamraju wrote:
> This patch implements an in-kernel gdb stub.
> It provides an interface between gdb and Linux Kernel by implementing
> the remote serial protocol.  This gdbstub uses utrace infrastructure.
> This patch provides register set access, signal mapping, process event
> handling, input/output operations.
> 
> /proc/<pid>/gdb was chosen as file for gdb to interact with the
> process through remote serial protocol. 
> 
> Hence users would have to use "target remote /proc/<pid>/gdb" command
> on gdb prompt to start using this infrastructure.
> 
> For Breakpointing support, gdbstub needs User space breakpointing
> layer and uprobes layer which will be posted later.

How does this compare to kgdb and related efforts?



