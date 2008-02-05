Return-Path: <linux-kernel-owner+w=401wt.eu-S1760574AbYBEUS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574AbYBEUS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYBEUSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:18:50 -0500
Received: from 1wt.eu ([62.212.114.60]:1733 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbYBEUSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:18:49 -0500
Date: Tue, 5 Feb 2008 20:31:56 +0100
From: Willy Tarreau <w@1wt.eu>
To: dann frazier <dannf@hp.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] 2.4: [SCSI] aacraid: Fix security hole
Message-ID: <20080205193155.GA25898@1wt.eu>
References: <20080205103327.GB1792@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205103327.GB1792@ldl.fc.hp.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dann,

On Tue, Feb 05, 2008 at 03:33:28AM -0700, dann frazier wrote:
> This is a 2.4 backport of a linux-2.6 change by Alan Cox.
> (commit 60395bb60e0b5e4e0808ac8eb07a92f6c9cdea1f)
> 
> It has been build-tested only (I don't have the hardware).
> CVE-2007-4308 was assigned for this issue.
> 
> Commit log from 2.6 follows.
> 
>   On the SCSI layer ioctl path there is no implicit permissions check for
>   ioctls (and indeed other drivers implement unprivileged ioctls). aacraid
>   however allows all sorts of very admin only things to be done so should
>   check.

OK, makes sense. I did not notice that one in 2.6, eventhough Alan clearly
stated a security hole in the subject.

I'm applying it now, thanks!

Willy

