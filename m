Return-Path: <linux-kernel-owner+w=401wt.eu-S1946369AbXD3Q4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946369AbXD3Q4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946388AbXD3Q4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:56:15 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:34790 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946369AbXD3Q4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:56:14 -0400
Subject: Re: [PATCH] [30/34] i386: convert the monitor thread to use the
	kthread API
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Andi Kleen <ak@suse.de>
Cc: ebiederm@xmission.com, patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070430155003.ABE6663AC@wotan.suse.de>
References: <20070430549.617098000@suse.de>
	 <20070430155003.ABE6663AC@wotan.suse.de>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 11:55:59 -0500
Message-Id: <1177952159.3674.39.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 17:50 +0200, Andi Kleen wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> This patch just trivially replaces kernel_thread and daemonize with a
> single call to kthread_run.

Actually, no, I'm checking out Christoph's full conversion now.  If it
works, I'll send it in via the voyager tree.

James


