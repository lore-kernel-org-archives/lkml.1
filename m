Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbXJVNK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbXJVNK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 09:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbXJVNKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 09:10:50 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:52539 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751899AbXJVNKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 09:10:49 -0400
Message-ID: <393058650.02921@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 22 Oct 2007 21:10:45 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 100% iowait on one of cpus in current -git
Message-ID: <20071022131045.GA5357@mail.ustc.edu.cn>
References: <200710220822.52370.maximlevitsky@gmail.com> <200710221421.21439.maximlevitsky@gmail.com> <393056632.00561@ustc.edu.cn> <200710221505.35397.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710221505.35397.maximlevitsky@gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 03:05:35PM +0200, Maxim Levitsky wrote:
> Hi,
> Thank you very much too, for helping me.

You are welcome :-)

> Applied.
> Had to kill klogd, since kernel generates tons of redirtied inode messages.
> Size of the kern.log is 863 KB, thus I I don't think it is polite to attachit.
> Don't know whenever it is ok to put it on pastebin too.
> 
> Anyway, it shows lots of redirtied inode... messages,
> and while most of them are "at 08:02(sda2)" , my reiserfs root partition, some are
> 
> "Oct 22 14:50:27 MAIN kernel: [   73.643794] redirtied inode 2582 size 0 at 00:0f(tmpfs), line 300."
> 
> " line 300" is shown always
> 
> (I have /var/run, /var/lock, /dev mounted as tmpfs, default kubuntu setup)

Thank you for the testing out.

Hmm, Maybe it's an reiserfs related issue.  Do you have the full log file?

Thank you,
Fengguang

