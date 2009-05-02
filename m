Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbZEBPmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbZEBPmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 11:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbZEBPmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 11:42:01 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51524 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755272AbZEBPmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 11:42:00 -0400
Subject: Re: [PATCH 04/16] DRBD: bitmap
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
In-Reply-To: <1241090812-13516-5-git-send-email-philipp.reisner@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-4-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-5-git-send-email-philipp.reisner@linbit.com>
Content-Type: text/plain
Date: Sat, 02 May 2009 10:41:58 -0500
Message-Id: <1241278918.3639.46.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-30 at 13:26 +0200, Philipp Reisner wrote:
> DRBD maintains a dirty bitmap in case it has to run without peer node or
> without local disk. Writes to the on disk dirty bitmap are minimized by the
> activity log (=AL). Each time an extent is evicted from the AL the part of
> the bitmap no longer covered by the AL is written to disk.
> 
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

The way the bitmap and activity log work are very similar to the way the
md bitmap works (and are implemented for almost exactly the same
reason).  Is there any way we could combine them?

James


