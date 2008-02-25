Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbYBYUgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbYBYUgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbYBYUgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:36:43 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756390AbYBYUgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:36:42 -0500
Date: Mon, 25 Feb 2008 12:34:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "J.C. Pizarro" <jcpiza@gmail.com>
Cc: "Rik van Riel" <riel@redhat.com>, "Mike Galbraith" <efault@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Please, put 64-bit counter per task and incr.by.one each ctxt
 switch.
Message-Id: <20080225123439.90645f2f.akpm@linux-foundation.org>
In-Reply-To: <998d0e4a0802240512t859c5a1y3c30bd401530a43@mail.gmail.com>
References: <998d0e4a0802231908h37978d07wa5379d5c01b2c2ee@mail.gmail.com>
	<20080223221750.429cf0d9@bree.surriel.com>
	<998d0e4a0802232008w5c6566f0se15ab749ec6f1ceb@mail.gmail.com>
	<20080223232651.41dffa72@bree.surriel.com>
	<998d0e4a0802240512t859c5a1y3c30bd401530a43@mail.gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008 14:12:47 +0100 "J.C. Pizarro" <jcpiza@gmail.com> wrote:

> It's statistic, yes, but it's a very important parameter for the CPU-scheduler.
> The CPU-scheduler will know the number of context switches of each task
>  before of to take a blind decision into infinitum!.

We already have these:

        unsigned long nvcsw, nivcsw; /* context switch counts */

in the task_struct.
