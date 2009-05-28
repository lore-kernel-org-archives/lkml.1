Return-Path: <linux-kernel-owner+w=401wt.eu-S1763225AbZE1OT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763225AbZE1OT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758410AbZE1OTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:19:03 -0400
Received: from smtp.nokia.com ([192.100.105.134]:21825 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759166AbZE1OTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:19:00 -0400
Message-ID: <4A1E9C13.7030406@gmail.com>
Date: Thu, 28 May 2009 17:13:39 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 04/11] writeback: switch to per-bdi threads for flushing
 data
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <1243511204-2328-5-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1243511204-2328-5-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2009 14:13:41.0636 (UTC) FILETIME=[80D9E440:01C9DF9E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> +#define BDI_CAP_FLUSH_FORKER	0x00000200

Would it please be possible to add a comment about
what this flag is, and whether it is for internal
usage or not. Not immediately obvious for me.

Artem.
