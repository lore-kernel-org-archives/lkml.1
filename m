Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbXEPQS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbXEPQS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbXEPQSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:18:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53930 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754648AbXEPQSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:18:20 -0400
Date: Wed, 16 May 2007 09:13:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Greg KH <greg@kroah.com>
Subject: Re: Oops and Panics in 2.6.21.1, 2.6.20.6 and 2.6.19.2
Message-Id: <20070516091346.3c76cb46.akpm@linux-foundation.org>
In-Reply-To: <464B2605.9040200@gmail.com>
References: <464A4F56.6080108@tequila.co.jp>
	<20070515185350.2e77bf21.akpm@linux-foundation.org>
	<464AE56F.3040101@gmail.com>
	<20070516082935.fe112ab5.akpm@linux-foundation.org>
	<464B2605.9040200@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 17:40:53 +0200 Tejun Heo <htejun@gmail.com> wrote:

> I see.  I thought there was different approach on fixing the problem.
> I'll try to backport the synchronization fix but am afraid it can be too
> risky for -stable.  If it seems too risky, I'll send a patch to disable
> reclamation.

OK.  Sad.  Maybe we add /proc/sys/fs/i-have-lots-of-disks-and-dont-mind-if-it-oopses
to enable the old behaviour.
