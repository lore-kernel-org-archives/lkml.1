Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZFEO7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZFEO7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZFEO7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:59:05 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:38343 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZFEO7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:59:05 -0400
Subject: Re: http://patchwork.kernel.org/patch/26483/ broke my system boot
From: Jon Masters <jonathan@jonmasters.org>
To: balbir@linux.vnet.ibm.com
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Robert Berger <robert.berger@reliableembeddedsystems.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090604063144.GB7504@balbir.in.ibm.com>
References: <20090603143944.GF29326@balbir.in.ibm.com>
	 <20090603194526.GG3100@uranus.ravnborg.org>
	 <20090604063144.GB7504@balbir.in.ibm.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Fri, 05 Jun 2009 03:17:12 -0400
Message-Id: <1244186233.11597.106.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-04 at 14:31 +0800, Balbir Singh wrote:
> * Sam Ravnborg <sam@ravnborg.org> [2009-06-03 21:45:26]:
> 
> > On Wed, Jun 03, 2009 at 10:39:44PM +0800, Balbir Singh wrote:
> > > After spending some time figuring out why my system failed to reboot,
> > > checking config options, kernel version, modules installed. I figured
> > > out that the patch in http://patchwork.kernel.org/patch/26483/ broke
> > > the system boot on the latest mmotm. Reverting it helped my system
> > > call depmod and hence boot.
> > > 
> > > The patch is really unhelpful, since the changelog is completely
> > > empty. Sigh!
> > 
> > Yeah, sorry for not nak'ing it earlier. Has been busy.
> > Andrew removed it from -mm and I notified the author about the
> > problems with the patch (in private mail it seems - I just replied to what I had).
> 
> Cool! Thanks for the update. I'll get the latest mmotm and test as
> well.

The general idea of using the cross-depmod is good though :) We have had
a few people recently run their newer host depmod and wonder why their
older embedded device can't read the new binary index files.

Jon.


