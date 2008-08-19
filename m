Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbYHSLJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbYHSLJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 07:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYHSLJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 07:09:25 -0400
Received: from ns1.suse.de ([195.135.220.2]:57642 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbYHSLJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 07:09:24 -0400
Date: Tue, 19 Aug 2008 13:09:20 +0200
From: Karsten Keil <kkeil@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ISDN fixes
Message-ID: <20080819110920.GB17310@pingi.kke.suse.de>
References: <20080819101225.GA17310@pingi.kke.suse.de> <1219141608.7591.118.camel@violet.holtmann.net> <87tzdhz46r.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87tzdhz46r.fsf@basil.nowhere.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.60-0.27-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 12:31:40PM +0200, Andi Kleen wrote:
> Marcel Holtmann <marcel@holtmann.org> writes:
> 
> > Hi Karten,
> >
> >> please pull the ISDN fixes from
> >> git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master
> >
> > can you include "git-diff -M --stat --summary" and "git-shortlog" in the
> > pull requests so others know what changes are in your tree.
> 
> The easiest way to do that is git request-pull (just to save you
> some manpage reading, Karsten) 

Thanks.

The following changes since commit 1fca25427482387689fa27594c992a961d98768f:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../aegl/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master

Harvey Harrison (2):
      mISDN: annotate iomem pointer and add statics
      mISDN: endian annotations for struct zt

Ilpo Järvinen (1):
      misdn: fix multistatement if block missing braces

Julia Lawall (1):
      drivers/isdn/capi/kcapi.c: Adjust error handling code involving capi_ctr_put

Karsten Keil (7):
      Cleanup hfc multiport driver
      Cosmetic fixes
      Fix lockdep warning

 Documentation/isdn/README.mISDN         |   10 ++--
 drivers/isdn/capi/kcapi.c               |    4 +
 drivers/isdn/hardware/mISDN/hfc_multi.h |    4 -
 drivers/isdn/hardware/mISDN/hfc_pci.h   |    4 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c  |  109 +++++++------------------------
 drivers/isdn/hardware/mISDN/hfcpci.c    |   23 +++----
 drivers/isdn/mISDN/dsp_cmx.c            |    3 +-
 drivers/isdn/mISDN/tei.c                |    2 +-
 8 files changed, 49 insertions(+), 110 deletions(-)


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
