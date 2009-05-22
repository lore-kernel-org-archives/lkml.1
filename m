Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbZEVNhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbZEVNhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 09:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757006AbZEVNhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 09:37:47 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:39887 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbZEVNhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 09:37:46 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Pantelis Koukousoulas <pktoss@gmail.com>
Subject: Re: How to tell whether a struct file is held by a process?
Date: Fri, 22 May 2009 15:38:08 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>
References: <ac3eb2510905211407l3aec14acx2572a2ad4e675b9@mail.gmail.com> <Pine.LNX.4.44L0.0905211724050.3914-100000@iolanthe.rowland.org> <1295ed070905220630q67c62569o9753425abf529742@mail.gmail.com>
In-Reply-To: <1295ed070905220630q67c62569o9753425abf529742@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221538.09073.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 22. Mai 2009 15:30:20 schrieb Pantelis Koukousoulas:
> The only problem I find with leaving mutual exclusion 100% to userspace and
> burdening the kernel only with the decision of whether a port should be
> handled by kernel or userspace is this:
>
> Suppose a device needs a reset as part of its init sequence (a whole lot
> of them do, this is not purely hypothetical). Then a different process may
> get to operate the device before and after the reset and hilarity may
> result from that.

If you leave the locking against user space to user space this can happen
any time, not just due to a reset. What is so special about reset? You just
need a user space locking scheme operating on port numbers, not device
addresses.

	Regards
		Oliver

