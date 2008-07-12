Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYGLNPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYGLNPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 09:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYGLNPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 09:15:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbYGLNPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 09:15:05 -0400
Date: Sat, 12 Jul 2008 06:14:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Vladislav Bogdanov <slava@nsys.by>
Subject: Re: [PATCH] quota: Implement sending information via netlink about
 user below quota
Message-Id: <20080712061446.ce779f6c.akpm@linux-foundation.org>
In-Reply-To: <12158660713206-git-send-email-jack@suse.cz>
References: <12158660713206-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2008 14:34:31 +0200 Jan Kara <jack@suse.cz> wrote:

> 
> Sometimes it may be useful for userspace to know (e.g. for some hosting guys)
> that some user stopped exceeding his hardlimit or softlimit in quotas.
> Implement sending of such events to userspace via quota netlink protocol so
> that they don't have to poll for such events. Based on idea and initial
> implementation by Vladislav Bogdanov <slava@nsys.by>.

Documentation/filesystems/quota.txt will need an update.
