Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbXIMLn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbXIMLn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 07:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXIMLnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 07:43:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:54044 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbXIMLns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 07:43:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=Rx/OpINLf04+5wNkq5gSwQW+fVjF6Ns9opOU8sDEVaWZbQBW6He/WTHZBmz7yhICuMkFw2/PdMeniRcsNBtr7FCpgbC0rL0R/vcnK8crHc9s2gToz6QpPIDHmpdWjOi18gx1d7YaUCsnKrngVPkMxqH8vWzPknPWwnjYiJ09pf4=
Message-ID: <46E9226F.9010700@gmail.com>
Date: Thu, 13 Sep 2007 13:43:43 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: 2.6.23-rc4-mm1: deadlock while mmaping video device
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have this circular lock dependency on 2.6.23-rc4-mm1 when opening
/dev/video0 and mmaping it. the v4l driver is stk11xx:
http://www.fi.muni.cz/~xslaby/sklad/panics/mm-deadlock.png

Using slub on x86_64 if that matters.

For now, I'm unable to set up a netconsole, so only the picture linked above
is the best I have.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
