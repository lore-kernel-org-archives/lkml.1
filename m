Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbZC3MSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbZC3MSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757208AbZC3MSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:18:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44855 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196AbZC3MSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:18:11 -0400
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/14] fs: scale inode alias list
From: Andi Kleen <andi@firstfloor.org>
References: <20090329155539.275927173@nick.local0.net>
	<20090329155749.455863870@nick.local0.net>
Date: Mon, 30 Mar 2009 14:18:07 +0200
In-Reply-To: <20090329155749.455863870@nick.local0.net> (npiggin@suse.de's message of "Mon, 30 Mar 2009 02:55:47 +1100")
Message-ID: <87zlf3mcg0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

npiggin@suse.de writes:

> Add a new lock, dcache_inode_lock, to protect the inode's i_dentry list
> from concurrent modification. d_alias is also protected by d_lock.

This would seem to ask for per object lock? Why not put it into the inode?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
