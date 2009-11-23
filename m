Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbZKWIdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbZKWIdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 03:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZKWIdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 03:33:08 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48819 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbZKWIdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 03:33:08 -0500
Date: Mon, 23 Nov 2009 09:33:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
       brace@beardog.cce.hp.com
Subject: Re: [PATCH] cciss: fix scatter gather cleanup problems
Message-ID: <20091123083313.GT8742@kernel.dk>
References: <20091118203418.8353.83196.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118203418.8353.83196.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18 2009, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> cciss: fix scatter gather cleanup problems
> On driver unload, only free up the extra scatter gather data
> if they were allocated in the first place (the controller
> supports it) and don't forget to free up the sg_cmd_list
> array of pointers.

Thanks, applied.

-- 
Jens Axboe

