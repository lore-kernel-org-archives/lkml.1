Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbXBSGV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbXBSGV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 01:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932133AbXBSGV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 01:21:26 -0500
Received: from 1wt.eu ([62.212.114.60]:2480 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131AbXBSGV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 01:21:26 -0500
Date: Mon, 19 Feb 2007 07:21:21 +0100
From: Willy Tarreau <w@1wt.eu>
To: Phy Prabab <phyprabab@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about setting affinity in 2.4
Message-ID: <20070219062121.GA27518@1wt.eu>
References: <2fe399760702181802q39e75b42iea7f80124506f169@mail.gmail.com> <20070219043927.GE943@1wt.eu> <2fe399760702182114v33f6825ckef91936c4a28b3f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fe399760702182114v33f6825ckef91936c4a28b3f1@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 09:14:21PM -0800, Phy Prabab wrote:
> Willy,
> 
> Thanks for the heads up and patch location.  It looks like the guys at
> RH seemed to have applied a patch to allow one to set affinity,
> however, it might be that it is broken.  Guess I will have to contact
> the RH people to get an update as to what they did/did not do.

You should ensure that the syscall has really been added to the syscall
table. Their kernel also has a fully working epoll() implementation, but
the syscall is missing from the table. It's a shame because you have to
add a 10-lines patch to enable it again ! It may be the same problem in
your case.

> Thanks!
> Phy

Regards,
Willy

