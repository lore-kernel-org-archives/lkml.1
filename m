Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbYDIGbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbYDIGbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 02:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYDIGb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 02:31:26 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:7151 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbYDIGbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 02:31:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sSDLqvGFpTlCpx6rFDULJrxQE0SP8hgtkon+8LNjwIZVYexHo5osau/g+3DmV7OMnMkGvxh8QqJ8mJRJ4HKF//J2BkPS82882Hg2lDKeoA4deNjl9/34z9ay7hAQ3PQeP1rer8xv9UaaaY7jljbaoMxyvOR2cTt3yG8jfxFvYxs=
Message-ID: <cfd18e0f0804082331q520d335cgb46972d79a257b63@mail.gmail.com>
Date: Wed, 9 Apr 2008 08:31:20 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: signalfd() not handling sigqueue() sigval data correctly
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804081636450.28275@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47FBDF12.8090400@gmail.com>
	 <Pine.LNX.4.64.0804081636450.28275@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2008 at 1:37 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Tue, 8 Apr 2008, Michael Kerrisk wrote:
>
> > Hi Davide,
> >
> > I was doing some playing about with signalfd(), and seem to have encountered a
> > bug: when a signalfd read() fetches data for a signal that was sent by
> > sigqueue(), the data accompanying the signal is not returned.  Instead
> > ssi_int/ssi_ptr is zero.
>
> Are you able to fetch those info with, say, sigtimedwait(2)?

Yes.


-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug? Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
