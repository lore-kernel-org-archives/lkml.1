Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808Ab0A0AFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab0A0AFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763Ab0A0AFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:05:47 -0500
Received: from kroah.org ([198.145.64.141]:35107 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab0AZXnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:03 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:22 2010
Message-Id: <20100126233922.168136430@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hemant Pedanekar <hemantp@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [10/98] davinci: dm646x: Add support for 3.x silicon revision
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hemant Pedanekar <hemantp@ti.com>

commit f63dd12da29f47c37bbc093abec098538e04357c upstream.

DM6467 silicon revisions 3.x have variant field in JTAGID register as '1'.
This path adds entry for the same in dm646x_ids to be able to boot on boards
with 3.x revision chips.

Also modifies name for 'variant=0' (revisions 1.0, 1.1).

Signed-off-by: Hemant Pedanekar <hemantp@ti.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-davinci/dm646x.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -789,7 +789,14 @@ static struct davinci_id dm646x_ids[] = 
 		.part_no	= 0xb770,
 		.manufacturer	= 0x017,
 		.cpu_id		= DAVINCI_CPU_ID_DM6467,
-		.name		= "dm6467",
+		.name		= "dm6467_rev1.x",
+	},
+	{
+		.variant	= 0x1,
+		.part_no	= 0xb770,
+		.manufacturer	= 0x017,
+		.cpu_id		= DAVINCI_CPU_ID_DM6467,
+		.name		= "dm6467_rev3.x",
 	},
 };
 


