Return-Path: <linux-kernel-owner+w=401wt.eu-S932814AbYCSXSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbYCSXSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938553AbYCSVqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:46:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S938547AbYCSVqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:46:37 -0400
Date: Wed, 19 Mar 2008 14:43:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: randy.dunlap@oracle.com, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][v4]  Modify loop device to be able to manage partitions
 of the disk image
Message-Id: <20080319144348.c235508c.akpm@linux-foundation.org>
In-Reply-To: <1205962750.4758.17.camel@frecb07144>
References: <12058427603971-git-send-email-Laurent.Vivier@bull.net>
	<12059301672966-git-send-email-Laurent.Vivier@bull.net>
	<20080319131106.61d7fa0c.randy.dunlap@oracle.com>
	<1205958281.4758.7.camel@frecb07144>
	<20080319142821.73d280f3.akpm@linux-foundation.org>
	<1205962750.4758.17.camel@frecb07144>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 22:39:10 +0100
Laurent Vivier <Laurent.Vivier@bull.net> wrote:

> > > > What happened to the update to Documentation/kernel-parameters.txt
> > > > that was in v3?
> > > 
> > > Well, perhaps I didn't understand the comment of Andrew:
> > > 
> > > "This shouldn't be needed."
> > > 
> > > I though it means I should remove it. So, Andrew ???
> > 
> > No, given that all module_param() options are available via the boot
> > command line when the module is linked into vmlinux, we don't document them
> > separately.
> 
> "No" is "To document max_part is not needed"
> 
> or
> 
> "No" is "you must not remove parameter documentation from your patch" ?

The former ;)
