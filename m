Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbYKYWns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbYKYWns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 17:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYKYWnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 17:43:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752801AbYKYWnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 17:43:16 -0500
Date: Tue, 25 Nov 2008 14:42:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       srostedt@redhat.com
Subject: Re: [PATCH 1/3] ftrace: add function tracing to single thread
Message-Id: <20081125144221.66eb99ad.akpm@linux-foundation.org>
In-Reply-To: <20081125223456.976670734@goodmis.org>
References: <20081125223421.795046329@goodmis.org>
	<20081125223456.976670734@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 17:34:22 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> This patch adds the ability to function trace a single thread.
> The file:
> 
>   /debugfs/tracing/set_ftrace_pid
> 
> contains the pid to trace.

What happens if the same pid exists in two or more pid namespaces?
