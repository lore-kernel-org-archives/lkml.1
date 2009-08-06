Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbZHFTOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbZHFTOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbZHFTOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:14:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51224 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbZHFTOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:14:07 -0400
Date: Thu, 6 Aug 2009 15:13:59 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       zhifeng.cai@atheros.com, stephen.chen@atheros.com,
       linux-usb@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: [PATCH] Document pci_ids.h addition policy.
Message-ID: <20090806191359.GA4345@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, zhifeng.cai@atheros.com,
	stephen.chen@atheros.com, linux-usb@vger.kernel.org,
	jbarnes@virtuousgeek.org
References: <1249523981-26601-1-git-send-email-lrodriguez@atheros.com> <1249532170.21101.3.camel@localhost.localdomain> <43e72e890908052126v53aa1b4sb7a48e19f98fdfa6@mail.gmail.com> <1249533357.21101.5.camel@localhost.localdomain> <20090806050932.GA25015@kroah.com> <20090806181546.GA11589@redhat.com> <20090806183326.GA28433@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806183326.GA28433@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 11:33:26AM -0700, Greg Kroah-Hartman wrote:
 
 > > I agree. In fact, I'd go further, and say that the bulk of what we have
 > > in pci_ids.h is also pointlessly shared. Only a tiny fraction of the device
 > > entries in that file are used by multiple files in the kernel.
 > 
 > I agree with that as well, which is why when I was PCI maintainer, I
 > didn't allow any new additions to the pci_ids.h file, unless it was
 > going to be an id that was shared by different drivers.  That cut the
 > new additions down to about none :)

Perhaps documenting this is a good idea to prevent things being moved there,
as it still seems to be happening judging from the git log.

Signed-off-by: Dave Jones <davej@redhat.com>
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 73b46b6..f9156fd 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2,6 +2,9 @@
  *	PCI Class, Vendor and Device IDs
  *
  *	Please keep sorted.
+ *
+ *	Do not add new entries to this file unless the definitions
+ *	are shared between multiple drivers.
  */
 
 /* Device classes and subclasses */
