Return-Path: <linux-kernel-owner+w=401wt.eu-S965872AbXGSRar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965872AbXGSRar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965678AbXGSRaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:30:09 -0400
Received: from brick.kernel.dk ([80.160.20.94]:20638 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965639AbXGSRaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:30:07 -0400
Date: Thu, 19 Jul 2007 19:29:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: Re: [PATCH] Cleanup elevator_ops->trim function
Message-ID: <20070719172949.GW11657@kernel.dk>
References: <469F7B4C.5050502@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F7B4C.5050502@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19 2007, Pavel Emelyanov wrote:
> The elevator_ops's member "trim" is declared and called not like
> all the other ones. Was this deliberate?

It's not a elevator action like the others, it's not called during
request handling, only for shutdown. So the different naming is actually
ok, it shows it's a different type of operation.

-- 
Jens Axboe

