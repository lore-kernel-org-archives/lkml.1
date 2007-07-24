Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbXGXITy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbXGXITy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbXGXITl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:19:41 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:34241 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbXGXITk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:19:40 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Towards eliminating the freezer
Date: Tue, 24 Jul 2007 10:21:35 +0200
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0707231124590.3545-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707231124590.3545-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707241021.35573.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 23 Juli 2007 schrieb Alan Stern:
> Now here's an idea which might work.  Can we require every caller of
> device_add() to hold some existing device's semaphore?  Normally it
> would be the semaphore of the new device's parent, but it could be a
> higher ancestor.  There even could be a single "root" semaphore for
> drivers registering a top-level device with no parent.

What prevents us from having a device addition semaphore?
Adding device is not critical to performance, is it?

	Regards
		Oliver
