Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbYA1DQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbYA1DQY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 22:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYA1DQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 22:16:15 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:40720 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754002AbYA1DQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 22:16:14 -0500
Message-ID: <401490185.02675@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 28 Jan 2008 11:16:06 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Sev Binello <sev@bnl.gov>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Many processes stuck in blk_congestion_wait
References: <4797BD62.1070608@bnl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4797BD62.1070608@bnl.gov>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JJKTe-0001Ha-Mr@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 05:19:14PM -0500, Sev Binello wrote:
> We are experiencing numerous hangs/slow downs on our WS4 U5 nfs client 
> machines (not seen on WS3).
> Many processes end up in a D state for long periods of time
> and are in  blk_congestion_wait().
> 
> Time in this state can vary,
> not sure what triggers them to come out, some don't
> But time in this state can be quite lengthy.

> Machines are running 2.6.9-55.0.9.ELsmp

It's a pretty old kernel.  If possible, a kernel upgrade may well fix
your problem.

