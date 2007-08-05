Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbXHESAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbXHESAu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 14:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbXHESAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 14:00:39 -0400
Received: from gw.goop.org ([64.81.55.164]:50306 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbXHESAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 14:00:38 -0400
Message-ID: <46B60FF4.3070208@goop.org>
Date: Sun, 05 Aug 2007 10:59:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>,
       James Smart <James.Smart@emulex.com>, Adrian Bunk <bunk@stusta.de>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>,
       Mark Hindley <mark@hindley.org.uk>
Subject: Re: [3/3] 2.6.23-rc2: known regressions
References: <46B5F74D.7010708@googlemail.com> <46B5FA39.5050907@googlemail.com>
In-Reply-To: <46B5FA39.5050907@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Virtualization
>
> Subject         : drivers/net/xen-netfront.c: bogus code
> References      : http://lkml.org/lkml/2007/7/22/256
> Last known good : ?
> Submitter       : Adrian Bunk <bunk@stusta.de>
> Caused-By       : ?
> Handled-By      : Jeremy Fitzhardinge <jeremy@goop.org>
> Status          : unknown
>   

This is just a chunk of dead code.  It probably doesn't even affect the
generated code.  I've got a patch here for it, and I'll probably post it
in the next day or so, but this seems like a non-issue.

    J
