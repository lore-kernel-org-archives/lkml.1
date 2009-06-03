Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbZFCWaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbZFCWaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 18:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZFCWaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 18:30:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44496 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZFCWaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 18:30:05 -0400
Date: Thu, 4 Jun 2009 00:30:06 +0200
From: Jan Kara <jack@suse.cz>
To: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp,
       linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, adrian.hunter@nokia.com,
       artem.bityutskiy@nokia.com
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Message-ID: <20090603223005.GA9050@atrey.karlin.mff.cuni.cz>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> 2. Make FAT and EXT2 file systems use the above mechanism to optionally
>    notify user space about errors. Implemented as 'notify' mount option
>    (PATCH 3,4).
>    FAT error reporting facilities had to be re-factored (PATCH 2) in 
>    order to simplify sending error notifications.
  One question: Why would not a filesystem / admin want the notification
to be sent? Or in other words what's the point of the mount option?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
