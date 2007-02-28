Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbXB1KzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbXB1KzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 05:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXB1KzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 05:55:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40554 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbXB1KzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 05:55:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: vatsa@in.ibm.com
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Date: Wed, 28 Feb 2007 11:57:27 +0100
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <200702261139.59130.rjw@sisk.pl> <20070227215314.GA427@tv-sign.ru> <20070228012301.GH29179@in.ibm.com>
In-Reply-To: <20070228012301.GH29179@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702281157.28381.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 February 2007 02:23, Srivatsa Vaddagiri wrote:
> On Wed, Feb 28, 2007 at 12:53:14AM +0300, Oleg Nesterov wrote:
> > I think it is good. Srivatsa?
> 
> Maybe additional comments on why we don't skip vfork kernel tasks may be good. 

Which is because we don't want the kernel threads to be frozen in unexpected
places, so we allow them to block freeze_processes() instead or to set
PF_NOFREEZE?

> Otherwise looks ok to me. Thanks Rafael for making the changes!

You're welcome. :-)

Greetings,
Rafael
