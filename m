Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbYIZTWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbYIZTWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYIZTWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:22:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:15023 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbYIZTWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:22:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=uZsFUW+IlOYxrhORqjmToe67KqT2A9oalBdiptViuUPwbN7c7ij3HJDbfX672G2z+P
         +DYPmEFD/FPR+wAgivZ/2BF+w2SeGCph21dFicD/W9W8aUJhOIqYrvXsUTTlDtbMR+UF
         BMHTn/Z83AB2B3KqP5ujUx9nNsHduUh5oowKs=
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Rt2400-devel] Bug in rt2x00 rt73usb driver in latest git kernel
Date: Fri, 26 Sep 2008 21:22:34 +0200
User-Agent: KMail/1.9.9
Cc: rt2400-devel@lists.sourceforge.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Paul Eddington <eddingtonpaul@googlemail.com>,
       linux-kernel@vger.kernel.org, Iwo Mergler <iwo@call-direct.com.au>
References: <762793250809241102n61ea8f00kca8138bc3c8df2e6@mail.gmail.com> <200809262053.39930.IvDoorn@gmail.com> <20080926190408.GE3483@tuxdriver.com>
In-Reply-To: <20080926190408.GE3483@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809262122.34259.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2008, John W. Linville wrote:
> On Fri, Sep 26, 2008 at 08:53:39PM +0200, Ivo van Doorn wrote:
> > On Friday 26 September 2008, Ivo van Doorn wrote:
> > > On Friday 26 September 2008, Rafael J. Wysocki wrote:
> 
> > > > Well, according to the information I've received from Paul this particular
> > > > problem is a regression from 2.6.26, so it's been added to the list of recent
> > > > regressions.
> > > 
> > > Seriously, this error message is the most annoying rt2x00 error message _ever_.
> > > It should have been fixed 3 kernels ago, but it keeps popping up again and again.
> > > 
> > > Paul, what is the git commit id with which you encountered this bug?
> > 
> > Oh and please test rt2x00.git as well, since some patches which should fix this issue
> > are in there (and in wireless-testing.git) but not in Linus' tree since they are scheduled
> > for 2.6.28.
> 
> Can you identify which fixes those are likely to be?

It is at least this one, I need to double check if there are any others as well.

rt2x00: Fix race conditions in flag handling
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=9fe32736d2cf27dfbf25cb7536c4358cd0dab6de

> John
> 
> P.S.  Of course, as you pointed out this isn't a new bug.  Since it
> existed in 2.6.26, then technically it isn't a regression under
> current merging practices as I understand them.

Exactly, the bug has been there since rt2x00 arrived in 2.6.24 but because
it is a race condition which occurs on rare occasions only it isn't reported that
often. In 2.6.26 were some fixes which made the occurence rate even smaller,
but they were still there for some users.

Ivo
