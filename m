Return-Path: <linux-kernel-owner+w=401wt.eu-S1763850AbYHFB1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763850AbYHFB1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 21:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYHFB1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 21:27:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:39632 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbYHFB1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 21:27:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:date:user-agent:mime-version:content-disposition:subject
         :content-type:content-transfer-encoding:message-id;
        b=NMnWufEP82e44AT0R2nO7fdRyn1nK2eDae4tPX09PlsnZTMtZ6OwIMXdINYsMW7Fpj
         eeXzCUY5+W/RzLQS4yYjRkV0FQGdgSC+kOKFI29kCvjNRHK2H+VeM1PdBziGFVReesHB
         VopvoqmsZAzOIs9k9a5mu6B8PKV3+yfxHVjNY=
From: Michael Brennan <brennan.brisad@gmail.com>
To: linux-kernel@vger.kernel.org
Date: Wed, 6 Aug 2008 03:25:54 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Disposition: inline
Subject: Waking up from suspend regression
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200808060325.54537.brennan.brisad@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am having some major problems with the newest kernels on my Thinkpad R61i 
and I'm doing my best trying to debug the problems.

One problem is waking up from suspend to RAM. Earlier kernels worked fine 
(e.g. 2.6.25), but with the latest the system is unusable after waking up.
When trying to wake the computer up it first is completely unresponsive with a 
black screen. After about 40 seconds it comes back alive and shows the locked 
screensaver. But whatever I do I just get error messages, trying to unlock 
the screen, it says authentication failed for some reason. If I try to log in 
from console I just get kernel messages about I/O errors from the SATA HDD.

I have bisected this and get this behavior after the patch: 
[ce6fce4295ba727b36fdc73040e444bd1aae64cd] PCI MSI: Don't disable MSIs if the 
mask bit isn't supported

I hope this is of any help at all.

Thanks

-- 
Michael Brennan
