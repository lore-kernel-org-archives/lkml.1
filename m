Return-Path: <linux-kernel-owner+w=401wt.eu-S1751178AbZIIC56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbZIIC56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZIIC56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:57:58 -0400
Received: from fifo99.com ([67.223.236.141]:47801 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbZIIC55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:57:57 -0400
Subject: Re: [PATCH v2 2/5] Use new __init_task_data macro in arch
 init_task.c files.
From: Daniel Walker <dwalker@fifo99.com>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Joe Perches <joe@perches.com>
In-Reply-To: <1252464546-26394-3-git-send-email-tabbott@ksplice.com>
References: <1252464546-26394-1-git-send-email-tabbott@ksplice.com>
	 <1252464546-26394-3-git-send-email-tabbott@ksplice.com>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 19:58:19 -0700
Message-Id: <1252465099.14793.49.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 22:49 -0400, Tim Abbott wrote:
> +union thread_union init_thread_union __init_task_data =
> +       { INIT_THREAD_INFO(init_task) };


All the lines like the above are all producing checkpatch errors.. It
looks like the open brace needs to be up with the equals ..

Daniel


