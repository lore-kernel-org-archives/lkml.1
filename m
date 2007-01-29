Return-Path: <linux-kernel-owner+w=401wt.eu-S1750919AbXA2KPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750919AbXA2KPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 05:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbXA2KPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 05:15:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:60114 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbXA2KPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 05:15:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=bB+Rskv+gy5RhTZoNSXL4kxfNsdDALby7p39N1SfYDZ2KiKblHfbIKxH+pqayRtR2mFc1Yah0lu75b4LKeDQQLYAe3XMPGEmnPoFg47pIQQJjw8uiSgrR8GffgIrpqk7WV1msRCndMkilQrjUrDs5ewnUUIrwcWjPg4UNayfBE8=
Message-ID: <45BDC927.3040804@googlemail.com>
Date: Mon, 29 Jan 2007 11:15:03 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: script that import patches from local mm-commits mbox and adds them
 to local -mm tree
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

At first, change this variable
path_to_mbox_file = '/home/michal/.thunderbird/uyw4at28.default/Mail/Local\ Folders/mm_new2'
Copy to a new mbox patches that appeared after 2.6.20-rc6-mm2, get 2.6.20-rc6-mm2
http://userweb.kernel.org/~akpm/2.6.20-rc6-mm2/2.6.20-rc6-mm2-broken-out.tar.gz
and run witcher inside source tree.

http://www.stardust.webpages.pl/ltg/files/tools/witcher/witcher.py

example series diff
http://www.stardust.webpages.pl/ltg/files/tools/witcher/witcher-series
(it's not perfect, but should work)

Happy testing.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)

