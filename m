Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbYLFH0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbYLFH0P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 02:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYLFHZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 02:25:58 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1876 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbYLFHZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 02:25:57 -0500
Subject: Re: [RFC v11][PATCH 03/13] General infrastructure for checkpoint
 restart
From: Joe Perches <joe@perches.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Linux Torvalds <torvalds@osdl.org>,
       Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       MinChan Kim <minchan.kim@gmail.com>, arnd@arndb.de, jeremy@goop.org
In-Reply-To: <1228498282-11804-4-git-send-email-orenl@cs.columbia.edu>
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu>
	 <1228498282-11804-4-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 23:26:06 -0800
Message-Id: <1228548366.13046.614.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 12:31 -0500, Oren Laadan wrote:
> diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
> new file mode 100644
> index 0000000..63f298f
> --- /dev/null
> +++ b/include/linux/checkpoint.h
[]
> +#define cr_debug(fmt, args...)  \
> +	pr_debug("[%d:c/r:%s] " fmt, task_pid_vnr(current), __func__, ## args)
> +

perhaps:

#define pr_fmt(fmt) "[%d:c/r:%s] " fmt, task_pid_vnr(current), __func__

and use pr_debug instead?


