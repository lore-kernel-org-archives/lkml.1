Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbZEIQKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbZEIQKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbZEIQKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:10:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:49904 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195AbZEIQK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:10:28 -0400
Message-ID: <4A05AAA4.9010806@kernel.org>
Date: Sun, 10 May 2009 01:09:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Mauelshagen@RedHat.com, dm-devel@RedHat.com, dan.j.williams@gmail.com
Subject: Re: [PATCH 2/3] scsi: add scsi_device->alt_capacity
References: <1241828002-12742-1-git-send-email-tj@kernel.org>	 <1241828002-12742-3-git-send-email-tj@kernel.org> <1241842999.6357.2.camel@mulgrave>
In-Reply-To: <1241842999.6357.2.camel@mulgrave>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 09 May 2009 16:09:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> This is done at slightly the wrong level.  Capacity is actually a
> property of struct scsi_disk not struct scsi_device ... shouldn't
> alt_capacity be at the same level?

Hmmm... I think that was my first try and then I moved it to sdev for
some reason I can't rememer now.  I'll look into it again and try to
move it into sdev.

Thanks.

-- 
tejun
