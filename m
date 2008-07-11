Return-Path: <linux-kernel-owner+w=401wt.eu-S1760076AbYGKTTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076AbYGKTTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759142AbYGKTSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:18:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759094AbYGKTSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:18:32 -0400
Date: Fri, 11 Jul 2008 12:17:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Wang Chen <wangchen@cn.fujitsu.com>
Subject: Re: [PATCH] Fix error handling in i2o_device_add()
Message-Id: <20080711121717.874b3ff9.akpm@linux-foundation.org>
In-Reply-To: <20080710120501.27638.83131.stgit@warthog.procyon.org.uk>
References: <20080710120501.27638.83131.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 13:05:02 +0100 David Howells <dhowells@redhat.com> wrote:

> Fix error handling in i2o_device_add() - sysfs_create_link() can return an
> error.

Please review -mm's i2o-handle-sysfs_create_link-failures.patch and see if
I should fix or replace that patch.

