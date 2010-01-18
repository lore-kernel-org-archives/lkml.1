Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938Ab0ARSuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab0ARSuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885Ab0ARSuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:50:09 -0500
Received: from kroah.org ([198.145.64.141]:46239 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab0ARSuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:50:07 -0500
Date: Mon, 18 Jan 2010 10:48:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.31.12
Message-ID: <20100118184800.GC25918@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.31.12 kernel.  All users of the
.31 kernel series are strongly encouraged to upgrade.

No, forget that, all users of the .31 kernel series as released by the
-stable team should move to the .32 kernel series as soon as possible.

This is the last .31 kernel release barring something really odd
happening, so please, everyone move to .32 now, I do not know of any
reason you should stick with .31 at this point in time.

The updated 2.6.31.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.31.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                         |    2 
 drivers/acpi/sleep.c             |   40 +++++++++++++++
 drivers/hwmon/adt7462.c          |    2 
 fs/fcntl.c                       |  102 +++++++++++++++++++++++++--------------
 fs/quota/dquot.c                 |    3 +
 kernel/audit_tree.c              |   13 +++-
 kernel/signal.c                  |    3 -
 net/bridge/netfilter/ebtables.c  |    6 ++
 net/ipv6/exthdrs.c               |    7 ++
 net/netfilter/nf_conntrack_ftp.c |   18 +++---
 10 files changed, 142 insertions(+), 54 deletions(-)

Al Viro (2):
      fix braindamage in audit_tree.c untag_chunk()
      fix more leaks in audit_tree.c tag_chunk()

Andi Kleen (1):
      kernel/signal.c: fix kernel information leak with print-fatal-signals=1

David S. Miller (1):
      ipv6: skb_dst() can be NULL in ipv6_hop_jumbo().

Florian Westphal (1):
      netfilter: ebtables: enforce CAP_NET_ADMIN

Greg Kroah-Hartman (1):
      Linux 2.6.31.12

Gustavo Maciel Dias Vieira (1):
      ACPI: add DMI entry for SCI_EN resume quirk on HP dv4

Jan Kara (1):
      quota: Fix dquot_transfer for filesystems different from ext4

Len Brown (2):
      ACPI: sleep: another HP DMI entry for init_set_sci_en_on_resume
      ACPI: DMI init_set_sci_en_on_resume for HP-Compaq C700

Linus Torvalds (1):
      fasync: split 'fasync_helper()' into separate add/remove functions

Patrick McHardy (1):
      netfilter: nf_ct_ftp: fix out of bounds read in update_nl_seq()

Roger Blofeld (1):
      hwmon: (adt7462) Fix pin 28 monitoring

Vaibhav Verma (1):
      ACPI: sleep: another HP/Compaq DMI entries for init_set_sci_en_on_resume

