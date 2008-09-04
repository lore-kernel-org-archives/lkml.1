Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYIDGwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYIDGwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 02:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYIDGwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 02:52:43 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:32791 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbYIDGwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 02:52:43 -0400
Date: Thu, 4 Sep 2008 08:52:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch] block: Minor comment fix
Message-ID: <20080904065238.GT20055@kernel.dk>
References: <48BF0C77.6020901@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BF0C77.6020901@am.sony.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03 2008, Geoff Levand wrote:
> Minor fix to the inline documentation of blk_release_queue().

Well, yes and know. If you notice, it's actually not an exported
function. Moving the documentation to blk_cleanup_queue() would be the
right thing to do, with an added explanation on how blk_release_queue()
actually does the real work once all references to the device has gone
away.

-- 
Jens Axboe

