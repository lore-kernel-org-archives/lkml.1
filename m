Return-Path: <linux-kernel-owner+w=401wt.eu-S932439AbXHVUXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbXHVUXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbXHVUXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:23:11 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3624 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbXHVUXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:23:10 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.23-rc3-mm1: inlining failures in sound/pci/hda/hda_codec.c
Date: Wed, 22 Aug 2007 22:23:03 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, perex@suse.cz
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708222223.04610.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This is from x86_32 with gcc 3.4.6:

  CC [M]  sound/pci/hda/hda_codec.o
sound/pci/hda/hda_codec.c: In function `snd_hda_codec_free':
sound/pci/hda/hda_codec.c:517: sorry, unimplemented: inlining failed in call to 'free_hda_cache': function body not available
sound/pci/hda/hda_codec.c:534: sorry, unimplemented: called from here
sound/pci/hda/hda_codec.c:517: sorry, unimplemented: inlining failed in call to 'free_hda_cache': function body not available
sound/pci/hda/hda_codec.c:535: sorry, unimplemented: called from here
make[3]: *** [sound/pci/hda/hda_codec.o] Error 1
make[2]: *** [sound/pci/hda] Error 2
make[1]: *** [sound/pci] Error 2
make: *** [sound] Error 2

Regards,

	Mariusz
