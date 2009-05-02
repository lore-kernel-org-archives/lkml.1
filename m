Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbZEBRbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbZEBRbH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 13:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbZEBRay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 13:30:54 -0400
Received: from [212.69.161.110] ([212.69.161.110]:34042 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbZEBRay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 13:30:54 -0400
Date: Sat, 2 May 2009 19:29:58 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 12/16] DRBD: variable_length_integer_encoding
Message-ID: <20090502172957.GD6466@racke>
References: <1241090812-13516-5-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-6-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-7-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-8-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-9-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-10-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-11-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-12-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-13-git-send-email-philipp.reisner@linbit.com> <1241279117.3639.51.camel@mulgrave.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241279117.3639.51.camel@mulgrave.int.hansenpartnership.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 10:45:17AM -0500, James Bottomley wrote:
> On Thu, 2009-04-30 at 13:26 +0200, Philipp Reisner wrote:
> > Encoding of our simple LRE compression scheme. It is very effective since
> > large parts of our bitmap are sparse.
> > 
> > Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> > Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> 
> This seems fine to me, but it needs to be in /lib as a separate module
> (which drbd would then select) so the compression can be made available
> to other users.

will do.

Thanks,

	Lars
