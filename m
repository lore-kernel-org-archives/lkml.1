Return-Path: <linux-kernel-owner+w=401wt.eu-S1030314AbXCONCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030314AbXCONCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 09:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030359AbXCONCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 09:02:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030314AbXCONCa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 09:02:30 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
Date: Thu, 15 Mar 2007 14:02:07 +0100
User-Agent: KMail/1.9.1
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, gregkh@suse.de,
       Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <20070314194337.5d439dab@gondolin.boeblingen.de.ibm.com> <20070315112725.7eadb7b7@gondolin.boeblingen.de.ibm.com> <Pine.LNX.4.64.0703151219540.12584@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0703151219540.12584@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703151402.08097.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 15. März 2007 13:31 schrieb Hugh Dickins:
> Quite apart from this mysterious "other task", I don't understand
> "access" either.
> 
> Perhaps "defer" would best capture the idea of another-task and
> maybe-delay?  sysfs_defer_work(), struct sysfs_deferred_work?

But we do not wish to defer or delay anything.
How about: sysfs_action_from_neutral_context

	Regards
		Oliver
