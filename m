Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbYGYULo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbYGYULo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYGYULe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:11:34 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49304 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYGYULd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:11:33 -0400
Date: Fri, 25 Jul 2008 13:11:26 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: rae l <crquan@gmail.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/scsi/aic94xx/: replace __FUNCTION__ with
	__func__
Message-ID: <20080725201126.GB7355@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <1216954114-31949-1-git-send-email-crquan@gmail.com> <20080725164253.GA7355@tree.beaverton.ibm.com> <91b13c310807251008o361bc39drfb6aa227cd9fd2f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91b13c310807251008o361bc39drfb6aa227cd9fd2f9@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 01:08:38AM +0800, rae l wrote:
> On Sat, Jul 26, 2008 at 12:42 AM, Darrick J. Wong <djwong@us.ibm.com> wrote:
> > On Fri, Jul 25, 2008 at 10:48:33AM +0800, Denis ChengRq wrote:
> >> Signed-off-by: Denis ChengRq <crquan@gmail.com>
> >
> > No justification or changelog?
> I think no more explanation needed, the subject is definite.
> 
> and no justification happened here, (there are justifications otherwhere)

It's not clear to _me_ the _reason_ for changing this.  I think you're
trying to implement C99 cleanups, but I don't know for sure and this is
the first I've heard of __FUNCTION__ -> __func__ changes.

Really all I wanted was the two words "per C99" at the end of the title
so that I don't have a "Why the heck did we change this?" moment six
months from now. :)

--D
