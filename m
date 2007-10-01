Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbXJABL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbXJABL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 21:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbXJABLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 21:11:21 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3243 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbXJABLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 21:11:20 -0400
Date: Sun, 30 Sep 2007 20:44:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc8-git4: Known regressions from 2.6.22
Message-ID: <20071001004436.GA7638@tuxdriver.com>
References: <200709302305.09861.rjw@sisk.pl> <20070930143012.ddff564c.randy.dunlap@oracle.com> <alpine.LFD.0.999.0709301443100.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.999.0709301443100.3579@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2007 at 02:44:41PM -0700, Linus Torvalds wrote:
> On Sun, 30 Sep 2007, Randy Dunlap wrote:
> > On Sun, 30 Sep 2007 23:05:09 +0200 Rafael J. Wysocki wrote:
> > > 
> > > Subject:	build #301 failed for 2.6.23-rc6-g0d4cbb5 in linux/drivers/net/wireless/libertas/
> > > Submitter:	Toralf Förster <toralf.foerster@gmx.de>
> > > References:	http://lkml.org/lkml/2007/9/11/150
> > > 		http://bugzilla.kernel.org/show_bug.cgi?id=9077
> > > Patch:		http://bugzilla.kernel.org/attachment.cgi?id=12963&action=view
> > 
> > I'm told that this is already patched in the net-2.6.24 git tree,
> > but it should be merged for 2.6.23 IMO.
> 
> Jeff, John?
> 
> Build errors like this may not be a huge deal, but the fix looks 
> worthwhile anyway, so is there any reason this hasn't been sent upstream?

My mistake -- I thought this was a problem introduced in the patches
queued for 2.6.24.

Feel free to pull from here:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git fixes-jgarzik

Thanks!

John

---

The following changes since commit 4942de4a0e914f205d351a81873f4f63986bcc3c:
  Linus Torvalds (1):
        Linux 2.6.23-rc8

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git fixes-jgarzik

Randy Dunlap (1):
      libertas: build problems when partially modular

 drivers/net/wireless/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index ef35bc6..4eb6d97 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -43,7 +43,7 @@ obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
 obj-$(CONFIG_PCMCIA_WL3501)	+= wl3501_cs.o
 
 obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
-obj-$(CONFIG_LIBERTAS_USB)     += libertas/
+obj-$(CONFIG_LIBERTAS)		+= libertas/
 
 rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o
 obj-$(CONFIG_RTL8187)	+= rtl8187.o
-- 
John W. Linville
linville@tuxdriver.com
