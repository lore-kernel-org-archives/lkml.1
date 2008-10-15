Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYJOMjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYJOMjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 08:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYJOMjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 08:39:00 -0400
Received: from styx.suse.cz ([82.119.242.94]:50804 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752706AbYJOMi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 08:38:59 -0400
Date: Wed, 15 Oct 2008 14:38:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID fixes
Message-ID: <alpine.LNX.1.10.0810151247480.26779@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive Kconfig fixes for HID. The patch from Adrian removes the 
depends/select combination that is not properly supported by Kconfig and 
fixes the possible build error caused by this.

Thanks.

 drivers/hid/Kconfig |  122 ++++++++++++++++++++------------------------------
 1 files changed, 49 insertions(+), 73 deletions(-)

Adrian Bunk (1):
      HID: fix default building of all quirky devices

Jiri Kosina (1):
      HID: fix/improve help texts for quirk drivers

