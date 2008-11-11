Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYKKU7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYKKU7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYKKU6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:58:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873AbYKKU6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:58:21 -0500
Date: Tue, 11 Nov 2008 12:56:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, srostedt@redhat.com
Subject: Re: [PATCH 1/1] ring-buffer: buffer record on/off switch
Message-Id: <20081111125645.4f7a5827.akpm@linux-foundation.org>
In-Reply-To: <20081111201034.315528609@goodmis.org>
References: <20081111200601.147669239@goodmis.org>
	<20081111201034.315528609@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 15:06:02 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> +static struct file_operations rb_simple_fops = {

should be const...

Probably it isn't worth fixing.  Someone(tm) should do period sweeps -
10% of our file_operationses aren't const.

