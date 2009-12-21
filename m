Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbZLUJfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbZLUJfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 04:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbZLUJfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 04:35:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:45525 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755774AbZLUJfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 04:35:45 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18w2iwipTIwdhYnFBz+BvMnAt5yPLbXAJtzATOb45
	ZvIpbRqTCjQ2Qv
Subject: Re: [stable] Regression in 2.6.32.2: segfault on halt
From: Mike Galbraith <efault@gmx.de>
To: Holger =?ISO-8859-1?Q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1261387782.25983.5.camel@marge.simson.net>
References: <pan.2009.12.19.15.10.48.851500@googlemail.com>
	 <20091220054847.GF32739@1wt.eu> <4B2E10C6.7050304@googlemail.com>
	 <20091220130616.GC9719@1wt.eu>  <4B2E264E.4090805@googlemail.com>
	 <1261319400.6105.27.camel@marge.simson.net> <4B2E4056.50708@googlemail.com>
	 <1261339759.9188.4.camel@marge.simson.net>
	 <4B2EA5F8.4030907@googlemail.com>
	 <1261372511.6048.3.camel@marge.simson.net>
	 <4B2F3DD3.5090506@googlemail.com>
	 <1261387782.25983.5.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 10:35:41 +0100
Message-Id: <1261388141.25983.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(hm, linux@vger.kernel.org bounces, changes to linux-kernel@vger.kernel.org)

On Mon, 2009-12-21 at 10:29 +0100, Mike Galbraith wrote:
> On Mon, 2009-12-21 at 10:20 +0100, Holger Hoffstätte wrote:
> > (back on list)
> > 
> > Mike Galbraith wrote:
> > > OK, please try the below.  If that fixes the problem, woohoo.  If not,
> > > it'd be best to try pulling/trying full tip to see _if_ there's an
> > > existing fix.
> > > 
> > > commit 6ad4c18884e864cf4c77f9074d3d1816063f99cd
> > > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Date:   Wed Nov 25 13:31:39 2009 +0100
> > > 
> > >     sched: Fix balance vs hotplug race
> > 
> > Woohoo! :)
> > I ironed this over a clean .32.2 and halt works fine again, without
> > reverting anything. Guess this should go into the next stable ASAP.
> 
> Excellent (color _me_ relieved;).  Thanks a bunch for confirmation.
> 
> 	-Mike

