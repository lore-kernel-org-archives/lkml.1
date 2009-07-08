Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZGHTPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZGHTPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbZGHTPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:15:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41988 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931AbZGHTPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:15:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Fix congestion_wait() sync/async vs read/write confusion
Date: Wed, 8 Jul 2009 21:15:21 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, chris.mason@oracle.com
References: <20090708184703.GW23611@kernel.dk>
In-Reply-To: <20090708184703.GW23611@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907082115.22104.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 July 2009, Jens Axboe wrote:
> Hi,
> 
> This one isn't great, we currently have broken congestion wait logic in
> the kernel. 2.6.30 is impacted as well, so this patch should go to
> stable too once it's in -git. I'll let this one simmer until tomorrow,
> then ask Linus to pull it. The offending commit breaking this is
> 1faa16d22877f4839bd433547d770c676d1d964c.
> 
> Meanwhile, it could potentially cause buffered writeout slowdowns in the
> kernel. Perhaps the 2.6.30 regression in that area is caused by this?
> Would be interesting if the submitter could test. I can't find the list,
> CC'ing Rafael.

Thanks, but I'm not sure which one do you mean in particular.
http://bugzilla.kernel.org/show_bug.cgi?id=13408 looks like it might be
somewhat related.

The complete list is at http://lkml.org/lkml/2009/7/6/383 .

Best,
Rafael
