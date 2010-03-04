Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab0CDTtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:49:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49160 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228Ab0CDTtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:49:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Hocko <mstsxfx@gmail.com>
Subject: Re: unable to handle kernel paging request on resume with 2.6.33-00001-gbaac35c
Date: Thu, 4 Mar 2010 20:52:39 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>, linux-mm@kvack.org
References: <20100301175256.GA4034@tiehlicka.suse.cz> <20100304090207.GA4640@tiehlicka.suse.cz> <201003042014.09444.rjw@sisk.pl>
In-Reply-To: <201003042014.09444.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003042052.39625.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 March 2010, Rafael J. Wysocki wrote:
> On Thursday 04 March 2010, Michal Hocko wrote:
> > On Wed, Mar 03, 2010 at 10:04:51PM +0100, Rafael J. Wysocki wrote:
> > > On Wednesday 03 March 2010, Michal Hocko wrote:
> > > > On Tue, Mar 02, 2010 at 09:01:21PM +0100, Rafael J. Wysocki wrote:
> > > > > On Tuesday 02 March 2010, Michal Hocko wrote:
> > > ...
> > > > > So this is just plain 2.6.33 plus one commit.
> > > > > 
> > > > > Hmm.  There are only a few changes directly related to hibernation in that
> > > > > kernel and none of them can possibly introduce a problem like that.
> > > > 
> > > > My previous kernel was vmlinux-2.6.33-rc8-00164-gaea187c and it didn't
> > > > show the problem.
> > > 
> > > Well, I have no idea which of the commits between -rc8 and .33 final might
> > > introduce such a problem.
> > > 
> > > What graphics is there in the affected box?
> > 
> > 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
> > 943/940GML Express Integrated Graphics Controller (rev 03))
> 
> Well, no clue.
> 
> The problem appears to be 32-bit specific, though, because I'm unable to
> reproduce it on any of my 64-bit boxes.

Well, this patch from Shaohua might help:

http://patchwork.kernel.org/patch/83497/

Rafael
