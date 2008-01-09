Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYAIUQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYAIUQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYAIUQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:16:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbYAIUP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:15:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] show_task: real_parent
In-Reply-To: Linus Torvalds's message of  Wednesday, 9 January 2008 08:03:51 -0800 <alpine.LFD.1.00.0801090800360.3148@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080109080323.8FCDC26F9A7@magilla.localdomain>
	<alpine.LFD.1.00.0801090800360.3148@woody.linux-foundation.org>
X-Zippy-Says: Can you MAIL a BEAN CAKE?
Message-Id: <20080109201516.ADAD326F9A8@magilla.localdomain>
Date: Wed,  9 Jan 2008 12:15:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with your points.  I thought about making it display both.
But I didn't want to worry about breaking scripts that parse console
logs or whatever.  Personally I don't think I've ever found the ppid
in that display useful in debugging a ptrace issue.  I don't have any
special opinions about this display.  I just went on a little crusade
to get rid of task_struct.parent uses that aren't specifically for
its ptrace/wait purpose.


Thanks,
Roland
