Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbZEVM0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbZEVM0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758399AbZEVM0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:26:21 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:46848 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360AbZEVM0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:26:20 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>, Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How to tell whether a struct file is held by a process?
Date: Fri, 22 May 2009 14:26:43 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
References: <Pine.LNX.4.44L0.0905210945290.2886-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0905210945290.2886-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905221426.43466.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thursday 21 May 2009 16:06:00 schrieben Sie:
> The problem is this.  Let D be the device plugged into port P.  When
> some program opens D's device file, it's necessary to check whether
> that same program has an open file reference for A(P), i.e., has opened

No. It is merely nice to do that, not necessary. You can take the position
that if the port is reserved the kernel won't touch the device but it is
user space's responsibility to not touch a device user space wants
to reserve.

Or alternatively, don't create the device file until user space tells
you to do so.

	Regards
		Oliver

