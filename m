Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZEEP5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZEEP5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbZEEP51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:57:27 -0400
Received: from [212.69.161.110] ([212.69.161.110]:54255 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbZEEP50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:57:26 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
Date: Tue, 5 May 2009 17:56:28 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: david@lang.hm, Willy Tarreau <w@1wt.eu>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>, Kyle Moffett <kyle@moffetthome.net>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <200905051021.33461.philipp.reisner@linbit.com> <1241532585.3312.13.camel@mulgrave.int.hansenpartnership.com>
In-Reply-To: <1241532585.3312.13.camel@mulgrave.int.hansenpartnership.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905051756.29703.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 May 2009 16:09:45 James Bottomley wrote:
> On Tue, 2009-05-05 at 10:21 +0200, Philipp Reisner wrote:
> > > > When you do asynchronous replication, how do you ensure that implicit
> > > > write-after-write dependencies in the stream of writes you get from
> > > > the file system above, are not violated on the secondary ?
> > >
[...]
> > > The way nbd does it (in the updated tools is to use DIRECT_IO and
> > > fsync).
> >
[...]
> I think you'll find the dio/fsync method above actually does solve all
> of these issues (mainly because it enforces the semantics from top to
> bottom in the stack).  I agree one could use more elaborate semantics
> like you do for drbd, but since the simple ones worked efficiently for
> md/nbd, there didn't seem to be much point.
>

Do I get it right, that you enforce the exact same write order on the 
secondary node as the stream of writes was comming in on the primary?

Using either DIRECT_IO or fsync() calls ?

Is DIRECT_IO/fsync() enabled by default ?

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

