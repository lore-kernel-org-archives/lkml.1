Return-Path: <linux-kernel-owner+w=401wt.eu-S933222AbXHVVSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222AbXHVVSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762980AbXHVVR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:17:58 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59517 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545AbXHVVR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:17:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46CCA7F3.3070404@s5r6.in-berlin.de>
Date: Wed, 22 Aug 2007 23:17:39 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux1394-user@lists.sourceforge.net
Subject: Notes on migrating to the new FireWire driver stack
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As many of you certainly noticed, Linux 2.6.22 has got a new FireWire
driver subsystem (nicknamed Juju) which is available as an independent
alternative to the classic IEEE 1394 subsystem.  Prompted by incoming
feedback, I now posted some basic hints on /if/ and /how/ to migrate to
the new FireWire drivers at
    http://wiki.linux1394.org/JujuMigration

In short, kernel packagers who want to provide FireWire support in Linux
2.6.22 and 2.6.23 should
  - build only the old drivers, or
  - build the old and the new drivers but blacklist the new drivers
    like described on the wiki, or
  - implement the necessary userspace integration for the new drivers.
    (That's what was done in Fedora 7.)  NB, neither does the wiki
    currently cover everything necessary for complete userspace
    integration, nor are the new drivers and respective compatibility
    extensions in FireWire userspace libraries feature-complete yet.

Kudos to all you out there who reported problems with the new drivers,
are helping us debugging the drivers, and contributed migration how-tos.
You know who you are.
-- 
Stefan Richter
-=====-=-=== =--- =-==-
http://arcgraph.de/sr/
