Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYA2Vo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYA2Vo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYA2VoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:44:21 -0500
Received: from lixom.net ([66.141.50.11]:58194 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbYA2VoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:44:20 -0500
Date: Tue, 29 Jan 2008 15:56:49 -0600
From: Olof Johansson <olof@lixom.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: system hang on latest git
Message-ID: <20080129215648.GB28997@lixom.net>
References: <1FE6DD409037234FAB833C420AA843EC75736A@orsmsx424.amr.corp.intel.com> <20080129201136.GX15220@kernel.dk> <20080129201648.GA15220@kernel.dk> <20080129214653.GA27978@lixom.net> <20080129213852.GF15220@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129213852.GF15220@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 10:38:52PM +0100, Jens Axboe wrote:
> Please try this.

[...]

> The latter is the problem, but since the queue lock is also held before
> doing the double_spin_lock(), we get into even more trouble. The locking
> hierarchy is fine, it's always queue lock -> io context locks, so the
> above patch should be all that is needed to fix this.
> 
> My initial analysis was wrong, that's all :/

Yep, looks much better now.

Tested-by: Olof Johansson <olof@lixom.net>


-Olof
