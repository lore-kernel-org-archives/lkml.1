Return-Path: <linux-kernel-owner+w=401wt.eu-S932297AbXJEVBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbXJEVBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932093AbXJEVBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:01:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49515 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762921AbXJEVBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:01:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [Q] APM depends on PM_SLEEP?
Date: Fri, 5 Oct 2007 23:16:09 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.60.0710051615350.10392@poirot.grange> <200710051749.52685.rjw@sisk.pl> <Pine.LNX.4.60.0710051827020.10392@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0710051827020.10392@poirot.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710052316.10215.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 5 October 2007 18:27, Guennadi Liakhovetski wrote:
> On Fri, 5 Oct 2007, Rafael J. Wysocki wrote:
> 
> > On Friday, 5 October 2007 16:18, Guennadi Liakhovetski wrote:
> > > Why does APM depend on PM_SLEEP?
> > 
> > Because APM uses the suspend core functions in drivers/base/power .
> 
> Ok, perhaps, a "select" would be better?...

Select doesn't work really well.

It probably would be better to add something like APM_SUSPEND
depending on SUSPEND.

Greetings,
Rafael
