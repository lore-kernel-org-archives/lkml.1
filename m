Return-Path: <linux-kernel-owner+w=401wt.eu-S1761896AbYAKP7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896AbYAKP7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759711AbYAKP7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:59:10 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:16683 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759005AbYAKP7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:59:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=b0T/RIhxkdxAussq7xc1cJu5ThdJhDuEACnLnGzki4oWPIOINEJ2n5zcKi6+0Z05q8njZdqFpjyCNnb7aWKRdn9s/NDv5KGifCAXiiGMeeqLrOMcfrJwl3e7hQVdKfNqw/3FpWKDxTPRlXCndzgFFVDeUQd/YfgK43vlEqhiBnc=
Message-ID: <661de9470801110759h318347acw5f08c91b48ca742d@mail.gmail.com>
Date: Fri, 11 Jan 2008 21:29:07 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: righiandr@users.sourceforge.net
Subject: Re: [RFC][PATCH] per-task I/O throttling
Cc: LKML <linux-kernel@vger.kernel.org>, "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <47869FFE.1050000@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47869FFE.1050000@users.sourceforge.net>
X-Google-Sender-Auth: b66be708ff1aa67e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2008 4:15 AM, Andrea Righi <righiandr@users.sourceforge.net> wrote:
> Allow to limit the bandwidth of I/O-intensive processes, like backup
> tools running in background, large files copy, checksums on huge files,
> etc.
>
> This kind of processes can noticeably impact the system responsiveness
> for some time and playing with tasks' priority is not always an
> acceptable solution.
>
> This patch allows to specify a maximum I/O rate in sectors per second
> for each single process via /proc/<PID>/io_throttle (default is zero,
> that specify no limit).
>
> Signed-off-by: Andrea Righi <a.righi@cineca.it>

Hi, Andrea,

We have been thinking of doing control group based I/O control. I have
not reviewed your patch in detail. I can suggest looking at openvz's
IO controller. I/O bandwidth control is definitely interesting. How
did you test your solution?

Balbir
