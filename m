Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbYCaUpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbYCaUpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 16:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbYCaUpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 16:45:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60200
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755430AbYCaUpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 16:45:10 -0400
Date: Mon, 31 Mar 2008 13:45:10 -0700 (PDT)
Message-Id: <20080331.134510.126138884.davem@davemloft.net>
To: achiang@hp.com
Cc: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: [ANNOUNCE] Btrfs v0.13
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080331202633.GA341@ldl.fc.hp.com>
References: <200802211609.50563.chris.mason@oracle.com>
	<20080331202633.GA341@ldl.fc.hp.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Chiang <achiang@hp.com>
Date: Mon, 31 Mar 2008 14:26:33 -0600

> I've gotten as far as successfully creating a btrfs filesystem
> (at least that's what btrfsck tells me), but haven't been able to
> mount it yet, probably because of the sector size issue.

You should be able to make a filesystem with a sector
size >= PAGE_SIZE and it should work just fine.  Please
give it a try.
