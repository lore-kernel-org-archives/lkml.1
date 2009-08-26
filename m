Return-Path: <linux-kernel-owner+w=401wt.eu-S1750911AbZHZED2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911AbZHZED2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 00:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbZHZED1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 00:03:27 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:43251 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZHZED0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 00:03:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=YWo+vmmMBvikRILj7fGaDoGfXvBEjl4YGxGD5yfURWQ4I69FAwBXtWOCLt+psC81BN
         A0FJC7zeevqhwrsB05jhS/5D4FcCGrWgVFc66nudKvx4DnoKFa+Olc7YOQm2IN9K48Cw
         XryVkX5tHsJxFhYruXsihXkao4ltSGCaMy+oc=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 25 Aug 2009 21:03:08 -0700
Message-ID: <43e72e890908252103j2332d8eat9e18fecb20a1fe58@mail.gmail.com>
Subject: Initial work for ar9271
To: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Cc: Christian Lamparter <chunkeey@web.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, Greg KH <greg@kroah.com>,
       Stephen Chen <Stephen.Chen@atheros.com>,
       Zhifeng Cai <zhifeng.cai@atheros.com>,
       Cliff Holden <Cliff.Holden@atheros.com>,
       Christoph Hellwig <hch@infradead.org>,
       Len Widra <Len.Widra@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atheros ar9271 support work is underway with the initial hardware
revision support already added on ath9k [1]. This driver shares a lot
of the framework used by ar6k so there may be potential of sharing
there. The final step of course is to add mac80211 support. ar9271
will just be the first of a few generation of firmware based Atheros
11n devices as such a different driver core will need to be written to
support these devices, specifically for usb its important as we need
to sleep during reads/writes, re-using ath9k as is may not quite do
it. To help iron out the specifics we would like to work with the
community on the rest of the driver. For now I've stuffed what I have
with a clean history on a git repo. If you'd like to work on the
driver I welcome patches:

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/ar9271.git

You can get the ar9271.fw firmware here:

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/athfw2lnx.git

I encourage really interested developers to please send me a note as
we would like to allocate sample cards for you.

Bare with me on the progress of the driver, this code is so new I
haven't even tested if firmware loading works but I think it may. At
least it compiles now.

I'm not yet sure if working with a separate repo or staging might be
best here as the driver does not yet give STA functionality, the whole
mac80211 driver part still remains to be developed. Lets play it by
ear, I'll see if we can get a mailing list created in the meantime
unless Greg doesn't mind me borrowing the driver project mailing list
for that.

[1] http://marc.info/?l=linux-wireless&m=124935567308276&w=2

  Luis
