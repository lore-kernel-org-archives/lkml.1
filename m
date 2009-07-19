Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbZGSOBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbZGSOBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 10:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbZGSOBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 10:01:10 -0400
Received: from relay1.sgi.com ([192.48.179.29]:46461 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754366AbZGSOBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 10:01:03 -0400
Date: Sun, 19 Jul 2009 09:01:02 -0500
From: Robin Holt <holt@sgi.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Commit 1e137f92 broke my Vaio VGN-FE550G's hda_intel driver.
Message-ID: <20090719140102.GI6876@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I finally got frustrated with not having sound available since 2.6.30
on and decided to bisect to the failure.  I got it narrowed down to:

commit 1e137f929bb490ff615ea475ac3904d58b0cdd5e
Author: Takashi Iwai <tiwai@suse.de>
Date:   Wed Jan 21 07:41:22 2009 +0100

    ALSA: hda - Clean up old VAIO hack codes for STAC9872

    Get rid of old VAIO static hack codes for STAC9872 and use the BIOS
    auto-parser for all models.


What information do you need from this machine in order to get the BIOS
auto-parser working for this model?

Thanks,
Robin
