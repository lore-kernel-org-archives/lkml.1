Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbZIYAFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbZIYAFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZIYAFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:05:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023AbZIYAFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:05:31 -0400
Date: Thu, 24 Sep 2009 17:05:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Brabec <utx@penguin.cz>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, linux@arm.linux.org.uk,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] serial-core: resume serial hardware with
 no_console_suspend
Message-Id: <20090924170503.37cbe4ed.akpm@linux-foundation.org>
In-Reply-To: <1253021938.6597.16.camel@hammer.suse.cz>
References: <1253021938.6597.16.camel@hammer.suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 15:38:58 +0200
Stanislav Brabec <utx@penguin.cz> wrote:

> Hardware may need re-initialization to get serial port working after
> resume. It does not happen with no_console_suspend. Attached patch
> attempts to fix it.
> 
> The patch attempts to keep hardware running before suspend and run
> hardware re-initialization after resume. Maybe simpler approach is
> possible.

The patch doesn't apply any more and seems like a rather hacky thing to do.

It appears that you have specific serial hardware which doesn't resume
correctly?  If so, that's a bug, so how about we start with a bug
report/description?


