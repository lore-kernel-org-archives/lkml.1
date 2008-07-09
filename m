Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbYGIU7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbYGIU7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbYGIU7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:59:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48276 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbYGIU7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:59:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: 2.6.26-rc7: BUG at kernel/power/snapshot.c:493
Date: Wed, 9 Jul 2008 23:00:59 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <1214584985.22228.15.camel@localhost> <20080709130823.GA21320@deprecation.cyrius.com>
In-Reply-To: <20080709130823.GA21320@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092300.59678.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 of July 2008, Martin Michlmayr wrote:
> * Soeren Sonnenburg <kernel@nn7.de> [2008-06-27 18:43]:
> > Anyone else seeing this? Happened after resuming from s2both (from
> > disk)...
> 
> FWIW, I got something similar a few days ago with s2disk and 2.6.25.
> I had never seen this before but then I got the same bug two or three
> times within a day.  It happens when resuming the laptop from disk.
> The kernel continues to start fine but doesn't restore the previous
> state.

This is a symptom of the userspace resume trying to feed invalid image
metadata to the kernel (yes, I'll have to change that code to return error
code in that case).

Please try to run mkswap on your resume partition and see if that helps.

Thanks,
Rafael
