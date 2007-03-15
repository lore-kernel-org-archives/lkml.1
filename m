Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbXCOMWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbXCOMWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 08:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933539AbXCOMWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 08:22:49 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26103 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760AbXCOMWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 08:22:48 -0400
Date: Thu, 15 Mar 2007 13:21:27 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splice: partial write handling fix
Message-ID: <20070315122127.GO15400@kernel.dk>
References: <871wjrg6qf.fsf@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871wjrg6qf.fsf@sw.ru>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14 2007, Dmitriy Monakhov wrote:
> currently if partial write has happened while ->commit_write() then page
> wasn't marked as accessed and rebalanced. 

The ->commit_write() return values aren't very well designed imho. Is
your fix correct getting the pipe_to_file() return value correct now?

-- 
Jens Axboe

