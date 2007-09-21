Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbXIUBUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbXIUBUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 21:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXIUBUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 21:20:08 -0400
Received: from home.nigel.suspend2.net ([203.171.70.205]:50451 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbXIUBUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 21:20:06 -0400
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Fri, 21 Sep 2007 11:19:59 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: nigel@suspend2.net, Pavel Machek <pavel@ucw.cz>,
       "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1190266447.21818.17.camel@caritas-dev.intel.com> <200709211024.35991.nigel@nigel.suspend2.net> <20070920180623.5d7da7b9.akpm@linux-foundation.org>
In-Reply-To: <20070920180623.5d7da7b9.akpm@linux-foundation.org>
Organization: Christian Reformed Churches of Australia
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211120.00448.ncunningham@crca.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Friday 21 September 2007 11:06:23 Andrew Morton wrote:
> On Fri, 21 Sep 2007 10:24:34 +1000 Nigel Cunningham 
<nigel@nigel.suspend2.net> wrote:
> 
> > Hi Andrew.
> > 
> > On Thursday 20 September 2007 20:09:41 Pavel Machek wrote:
> > > Seems like good enough for -mm to me.
> > > 
> > > 									Pavel
> > 
> > Andrew, if I recall correctly, you said a while ago that you didn't want 
> > another hibernation implementation in the vanilla kernel. If you're going 
to 
> > consider merging this kexec code, will you also please consider merging 
> > TuxOnIce?
> > 
> 
> The theory is that kexec-based hibernation will mainly use preexisting
> kexec code and will permit us to delete the existing hibernation
> implementation.
> 
> That's different from replacing it.

TuxOnIce doesn't remove the existing implementation either. It can 
transparently replace it, but you can enable/disable that at compile time.

Regards,

Nigel
-- 
Nigel Cunningham
Christian Reformed Church of Cobden
103 Curdie Street, Cobden 3266, Victoria, Australia
Ph. +61 3 5595 1185 / +61 417 100 574
Communal Worship: 11 am Sunday.
