Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYIDHLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYIDHLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 03:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYIDHK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 03:10:59 -0400
Received: from nebensachen.de ([195.34.83.29]:44297 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbYIDHK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 03:10:59 -0400
X-Hashcash: 1:20:080904:tiwai@suse.de::ob6ihF4EqE4h0xiH:000031kk
X-Hashcash: 1:20:080904:mchehab@infradead.org::xBGIqrT0jBAoNi4x:0000000000000000000000000000000000000000056N
X-Hashcash: 1:20:080904:linux-kernel@vger.kernel.org::ueH0UxQSsCN+m0Ix:0000000000000000000000000000000006E0b
From: Elias Oltmanns <eo@nebensachen.de>
To: Takashi Iwai <tiwai@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Stale files in linux-next
Date: Thu, 04 Sep 2008 09:10:52 +0200
Message-ID: <87fxogz8qr.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

the following files have been removed but are still tracked by git (this
is refering to next-20080903):

% git diff
% make clean
...
% git diff
diff --git a/drivers/media/dvb/dvb-usb/dtv5100-fe.c b/drivers/media/dvb/dvb-usb/dtv5100-fe.c
deleted file mode 100644
index e69de29..0000000
diff --git a/include/sound/ad1848.h b/include/sound/ad1848.h
deleted file mode 100644
index e69de29..0000000
diff --git a/sound/isa/ad1848/ad1848_lib.c b/sound/isa/ad1848/ad1848_lib.c
deleted file mode 100644
index e69de29..0000000
%

Could these files please be removed properly upstream? Hopefully, I have
addressed the right people.

Thanks,

Elias
