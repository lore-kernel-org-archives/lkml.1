Return-Path: <linux-kernel-owner+w=401wt.eu-S1759098AbZEBPp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098AbZEBPp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 11:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757051AbZEBPpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 11:45:19 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60771 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798AbZEBPpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 11:45:18 -0400
Subject: Re: [PATCH 12/16] DRBD: variable_length_integer_encoding
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
In-Reply-To: <1241090812-13516-13-git-send-email-philipp.reisner@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-4-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-5-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-6-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-7-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-8-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-9-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-10-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-11-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-12-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-13-git-send-email-philipp.reisner@linbit.com>
Content-Type: text/plain
Date: Sat, 02 May 2009 10:45:17 -0500
Message-Id: <1241279117.3639.51.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-30 at 13:26 +0200, Philipp Reisner wrote:
> Encoding of our simple LRE compression scheme. It is very effective since
> large parts of our bitmap are sparse.
> 
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

This seems fine to me, but it needs to be in /lib as a separate module
(which drbd would then select) so the compression can be made available
to other users.

James


