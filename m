Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZDUN6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZDUN6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZDUN5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:57:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40618 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbZDUN5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:57:53 -0400
Date: Tue, 21 Apr 2009 09:57:23 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: nauman@google.com, fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org,
       jmoyer@redhat.com, vgoyal@redhat.com, jens.axboe@oracle.com,
       agk@redhat.com, balbir@linux.vnet.ibm.com
Subject: Re: dm-ioband: Test results.
Message-ID: <20090421135723.GA13953@redhat.com>
References: <20090420.172959.193682665.ryov@valinux.co.jp> <e98e18940904200207y62eca680t7cf938049375f4b3@mail.gmail.com> <20090421.210614.112619728.ryov@valinux.co.jp> <20090421.211051.183023683.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421.211051.183023683.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21 2009 at  8:10am -0400,
Ryo Tsuruta <ryov@valinux.co.jp> wrote:

> Hi Nauman,
> 
> > > The real question is, once you create a version of dm-ioband that
> > > co-operates with CFQ scheduler, how that solution would compare with
> > > the patch set Vivek has posted? In my opinion, we need to converge to
> > > one solution as soon as possible, so that we can work on it together
> > > to refine and test it.
> > 
> > I think I can do some help for your work. but I want to continue the
> > development of dm-ioband, because dm-ioband actually works well and
> > I think it has some advantages against other IO controllers.
> >   - It can use without cgroup.
> >   - It can control bandwidth on a per partition basis.
> >   - The driver module can be replaced without stopping the system.
> 
> In addition, dm-ioband can run on the RHEL5.

RHEL5 compatibility does not matter relative to merging an I/O bandwidth
controller upstream.  So both the "can [be] use without cgroup" and "can
run on RHEL5" features do not help your cause of getting dm-ioband
merged upstream.  In fact these features serve as distractions.

Mike
