Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZJAMFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZJAMFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 08:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbZJAMFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 08:05:01 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:44597 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513AbZJAMFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 08:05:01 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Thu, 1 Oct 2009 14:04:37 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-prerelease; KDE/4.3.1; i686; ; )
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Rusty Russell <rusty@rustcorp.com.au>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <200910011228.30563.borntraeger@de.ibm.com> <20091001114244.GB12334@amit-x200.redhat.com>
In-Reply-To: <20091001114244.GB12334@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910011404.37601.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 01 Oktober 2009 13:58:01 schrieben Sie:
> I spawned two ports; one doing 'find /' and the other transferring a
> 800M file from the host to the guest, both running at the same time.
> This is on top of the latest Linus tree + my patches. It works fine.
> 
> Can you give me any additional info that can help me nail this down?

This is just a wild guess: My guest has 8 cpus and virtio requires that users do 
a proper locking. But as far as I see you use schedule_work which should be 
single threaded. 
Or maybe this is an existing bug that is just exposed by your patch - dont know. 

