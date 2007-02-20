Return-Path: <linux-kernel-owner+w=401wt.eu-S964777AbXBTTEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964777AbXBTTEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 14:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964788AbXBTTEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 14:04:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964777AbXBTTEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 14:04:49 -0500
Date: Tue, 20 Feb 2007 11:03:21 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Fix USB Mon breakage
Message-Id: <20070220110321.903fffed.zaitcev@redhat.com>
In-Reply-To: <20070220161541.GA20977@flint.arm.linux.org.uk>
References: <20070220161541.GA20977@flint.arm.linux.org.uk>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 16:15:41 +0000, Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> Never call __exit code from __init code - it causes errors such as:

Oh heh, just saw this now.

> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

I ack this. Greg, please either apply Dobriyan's patch, or this one,
they are the same.

-- Pete
