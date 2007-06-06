Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbXFFGzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbXFFGzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 02:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbXFFGz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 02:55:27 -0400
Received: from styx.suse.cz ([82.119.242.94]:57154 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758184AbXFFGzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 02:55:24 -0400
Date: Wed, 6 Jun 2007 08:55:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: young dave <hidave.darkstar@gmail.com>,
       "clameter@sgi.com" <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [BUG] 2.6.22-rc3-mm1 remove bluetooth usb adapter caused kmalloc
 bug
In-Reply-To: <20070605194236.03e07a1f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706060854520.10204@jikos.suse.cz>
References: <a8e1da0706051856g242dad96rf4286283192b06c4@mail.gmail.com>
 <20070605194236.03e07a1f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Andrew Morton wrote:

> Could perhaps be due to bluetooth-postpone-hci_dev-unregistration.patch, 
> but I don't see how.  (But that patch looks a bit dodgy wrt module 
> unload so I think I'll drop it).

It is perfectly fine to drop this one, as the issue it was trying to solve 
has been already fixed in a different way (commit 4ce61d1c7 in mainline).

-- 
Jiri Kosina
SUSE Labs
