Return-Path: <linux-kernel-owner+w=401wt.eu-S1764919AbZLQU0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764919AbZLQU0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 15:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764899AbZLQU0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 15:26:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47920 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764889AbZLQU0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 15:26:19 -0500
Date: Thu, 17 Dec 2009 20:26:13 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [revert] commit e9496ff46a20a8592fdc7bdaaf41b45eb808d310 needs to
	be reverted
Message-ID: <20091217202613.GD18217@ZenIV.linux.org.uk>
References: <1261075774.2868.16.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261075774.2868.16.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 01:49:34PM -0500, Eric Paris wrote:
> I pulled from Linus Dec16 and didn't have problems.  This is a pull from
> Dec17, plus some of my own patches which I'd be surprised to learn were
> related.  I have an NFS mount in my fstab, I assume this is that being
> mounted on boot.  I'll start a bisect if needed, but maybe someone will
> know what they broke instantly....

Gyah...  Please, revert e9496ff46a20a8592fdc7bdaaf41b45eb808d310;
it's dependent on a lot of other stuff not currently in mainline
and badly broken with current fs/namespace.c.  Sorry, badly out-of-order
cherry-pick from old queue.

