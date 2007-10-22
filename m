Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbXJVN3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbXJVN3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 09:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbXJVN3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 09:29:02 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:34045 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbXJVN3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 09:29:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=G/6hmIkkK19mrzBnJRo6Bj/fwLSbvsya7uPx3UCqrrddrS4T0Fq7AhClr5AFjNK29iIEYMvNOz2if27Pzx3ti3Qiuzlc3W+0YqWRCg7IWLtFWCf+rEwuUjojfgDDgHMj+0FPeipBWjH6eYyQezJx5bN3grnrHuaggA167M8aGCc=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: 100% iowait on one of cpus in current -git
Date: Mon, 22 Oct 2007 15:28:20 +0200
User-Agent: KMail/1.9.6
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200710220822.52370.maximlevitsky@gmail.com> <200710221505.35397.maximlevitsky@gmail.com> <393058650.02921@ustc.edu.cn>
In-Reply-To: <393058650.02921@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710221528.20369.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2007 15:10:45 Fengguang Wu wrote:
> On Mon, Oct 22, 2007 at 03:05:35PM +0200, Maxim Levitsky wrote:
> > Hi,
> > Thank you very much too, for helping me.
> 
> You are welcome :-)
> 
> > Applied.
> > Had to kill klogd, since kernel generates tons of redirtied inode messages.
> > Size of the kern.log is 863 KB, thus I I don't think it is polite to attachit.
> > Don't know whenever it is ok to put it on pastebin too.
> > 
> > Anyway, it shows lots of redirtied inode... messages,
> > and while most of them are "at 08:02(sda2)" , my reiserfs root partition, some are
> > 
> > "Oct 22 14:50:27 MAIN kernel: [   73.643794] redirtied inode 2582 size 0 at 00:0f(tmpfs), line 300."
> > 
> > " line 300" is shown always
> > 
> > (I have /var/run, /var/lock, /dev mounted as tmpfs, default kubuntu setup)
> 
> Thank you for the testing out.
> 
> Hmm, Maybe it's an reiserfs related issue.  Do you have the full log file?
No, I don't think so, like I said it sometimes shows the same message on tmpfs
> 
> Thank you,
> Fengguang
> 
> 
Best Regards,
	Maxim Levitsky
