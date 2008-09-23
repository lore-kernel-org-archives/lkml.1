Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbYIWOWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbYIWOWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbYIWOWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:22:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40324 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbYIWOWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:22:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: Re: Serious e1000e driver issue on Intrepid
Date: Tue, 23 Sep 2008 16:27:39 +0200
User-Agent: KMail/1.9.9
Cc: tim.gardner@canonical.com, ubuntu-devel@lists.ubuntu.com,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
References: <48D8EC11.9010700@canonical.com> <6278d2220809230657o33448333uf2e8fe421dd2244b@mail.gmail.com>
In-Reply-To: <6278d2220809230657o33448333uf2e8fe421dd2244b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809231627.40593.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 23 of September 2008, Daniel J Blueman wrote:
> Hi Tim,
> 
> [cross-posting to LKML]
> 
> On Tue, Sep 23, 2008 at 2:16 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> > Folks,
> >
> > There are beginning to be an increasing number of reports regarding a
> > serious regression in Intrepid with regard to the e1000e ethernet driver
> > wherein it can be rendered permanently inoperable. The original Bugzilla
> > report is here:
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=11382
> >
> > SuSE has also made an announcement regarding this issue:
> >
> > http://news.opensuse.org/2008/09/22/serious-e1000e-driver-issue-in-sle-11-beta-1-and-opensuse-111-beta-1
> >
> > Given the severity of this issue, I'm inclined to blacklist the driver
> > by default in modutils until such time as Intel develops a fix.
> >
> > How do we inform users when their ethernet suddenly stops working after
> > an update?
> 
> The 2.6.27-rc7 changelog shows this problem has been fixed for e1000:
> http://www.kernel.org/pub/linux/kernel/v2.6/testing/ChangeLog-2.6.27-rc7
> 
> and this patch in the -mm series fixes it for e1000e:
> http://marc.info/?l=linux-mm-commits&m=122038324200305&w=2

Well, actually this patch is against e1000, not e1000e and it's been merged
already.  Apparently, a separate fix for e1000e is necessary.

Thanks,
Rafael
