Return-Path: <linux-kernel-owner+w=401wt.eu-S1761631AbYG3Lp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631AbYG3Lp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761434AbYG3Lpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:45:42 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:33290 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761414AbYG3Lpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:45:41 -0400
X-Greylist: delayed 1915 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jul 2008 07:45:41 EDT
In-Reply-To: <1217307058.10237.13.camel@perihelion>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] request for comment: generic kernel	interface	for
 malware	vendors
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Wed, 30 Jul 2008 12:13:36 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 30/07/2008 12:13:36,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 30/07/2008 12:13:36,
	Serialize complete at 30/07/2008 12:13:36,
	S/MIME Sign failed at 30/07/2008 12:13:36: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 30/07/2008 12:13:39,
	Serialize complete at 30/07/2008 12:13:39
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080730111341.BA49F2FE875@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

malware-list-bounces@dmesg.printk.net wrote on 29/07/2008 05:50:58:

> On Mon, 2008-07-28 at 20:39 -0700, Greg KH wrote:
> > On Mon, Jul 21, 2008 at 12:18:07AM -0400, Eric Paris wrote:
> > > 
> > > This is a request for comment.  This is a first stab and I'm here to
> > > address all of the concerns that people have.  Please don't hold 
back,
> > > I've got thick skin.  BUT, I don't want to hear 'this is how we have
> > > been doing it, do it that way.'  I want to hear how this won't work 
for
> > > your needs (and WHY) or how we can do it better.
> > > 
> > > you can find the patches at:
> > > http://people.redhat.com/~eparis/talpa
> 
> Ouch. Adds a bunch of hooks outside of LSM - what's the plan here wrt.
> LSM, because LKML folks are going to ask :)

What is the plan with LSM is also a question? Is it gonna stay or be 
removed? Stacking looks like it will never happen and so it really doesn't 
cut it for this kind of use. Although it has hooks at the right places 
(I'm pretty sure but haven't looked in a while) for this first iteration. 

Tvrtko

P.S. How much is a bunch? I think there are just two hooks in this 
prototype.


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

