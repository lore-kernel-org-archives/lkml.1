Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbZHXVPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbZHXVPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZHXVPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:15:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753278AbZHXVPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:15:50 -0400
Date: Mon, 24 Aug 2009 14:15:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm snapshot: implement .iterate_devices
Message-Id: <20090824141536.30df105c.akpm@linux-foundation.org>
In-Reply-To: <1251007867-13004-1-git-send-email-snitzer@redhat.com>
References: <1251007867-13004-1-git-send-email-snitzer@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Aug 2009 02:11:07 -0400
Mike Snitzer <snitzer@redhat.com> wrote:

> This patch implements .iterate_devices for the origin and snapshot
> targets.  dm-snapshot's lack of .iterate_devices resulted in the
> inability to properly establish queue_limits for both targets.  
> 
> With 4K sector drives: an unfortunate side-effect of not establishing
> proper limits in either targets' DM device was that IO to the devices
> would fail even though both had been created without error.

Does this make the patch a regression fix?

> Commit af4874e03ed82f050d5872d8c39ce64bf16b5c38 should have implemented
> .iterate_devices for dm-snap.c's origin and snapshot targets.

Please use the form af4874e03ed82f050d5872d8c39ce64bf16b5c38 ("dm
target:s introduce iterate devices fn") when referring to commits. 
Because commits might have different IDs in different trees (I think
that's the reason).

