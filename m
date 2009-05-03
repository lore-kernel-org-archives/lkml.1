Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZECKF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZECKF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 06:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZECKFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 06:05:49 -0400
Received: from [212.69.161.110] ([212.69.161.110]:52338 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZECKFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 06:05:48 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
Date: Sun, 3 May 2009 12:06:22 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.27-9-generic; KDE/4.2.0; i686; ; )
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>, Kyle Moffett <kyle@moffetthome.net>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <e2e108260905020033h457ed97ayfd8392d1249a943a@mail.gmail.com> <20090503053557.GH570@1wt.eu>
In-Reply-To: <20090503053557.GH570@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905031206.32701.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 03 Mai 2009 07:36:00 schrieb Willy Tarreau:
> On Sat, May 02, 2009 at 09:33:35AM +0200, Bart Van Assche wrote:
> > On Fri, May 1, 2009 at 10:59 AM, Andrew Morton
> >
> > <akpm@linux-foundation.org> wrote:
> > > On Thu, 30 Apr 2009 13:26:36 +0200 Philipp Reisner 
<philipp.reisner@linbit.com> wrote:
> > >> This is a repost of DRBD
> > >
> > > Is it being used anywhere for anything? ?If so, where and what?
> >
> > One popular application is to run iSCSI and HA software on top of DRBD
> > in order to build a highly available iSCSI storage target.
>
> Confirmed, I have several customers who're doing exactly that.
>

Besides storage targets, DRBD is also very popular for databases,
it is widely used with PostgreSQL and MySQL. It is advertised by both
database projects, to use their DB on top of DRBD to form HA clusters.

Raw numbers of installations:

We have an opt-in global usage counter. See http://www.drbd.org/usage/year/
If we assume that 30% of all users agree that their DRBD installation gets
counted, then we have more then 12000 new installations in April.
(4245 Installations where counted)

It seems that nowadays most of our users get DRBD through their distributions. 
Distributions that include DRBD are (list incomplete): 
Debian, Ubuntu, SLES, CentOS

-Phil
