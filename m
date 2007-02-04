Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbXBDWbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbXBDWbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 17:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbXBDWbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 17:31:25 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:49587 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbXBDWbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 17:31:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=g1VAFFbjSXfEr7KumoKPLp5TOLWdpTH5Md/R62FT+5tYB1ONweFA9+ujlsekHsK+DRbQ8+R3+3Ymt1JwhjYsGlCGZPXkErfK/EorOobZUe+VgMbWnR1mUKyjdjMSkT/AL0T6B2ddiNAUUryEzpICGsvX4DMURQ8R0eBKMFDd0QE=
Message-ID: <82e4877d0702041431p555e644et35845db674304403@mail.gmail.com>
Date: Sun, 4 Feb 2007 17:31:23 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: linux-netdev@vger.kernel.org
Subject: Unexpected Acknowledgement / Stalled Connections
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am running 2.6.20 and have trouble with stalled connections. For
instance, if I try to download a debian ISO image using wget, the
connection runs fine for few seconds and then stalls for ever.

In my router logs I see a ton of messages like the below -

[INFO] Sun Feb 04 17:22:03 2007 Blocked incoming TCP packet from
192.168.0.174:34090 to 130.239.18.138:80 with unexpected
acknowledgement 3269301836 (expected 3269343453 to 3269408989)

Where 192.168.0.174 is my laptop running FC6 and kernel 2.6.20 and
130.239.18.138 is whatever cdimage.debian.org resolves to atm.

What's going on here? Any TCP/IP tunable that I can set/turn on/off to
prevent this from happening?

Thanks
Parag
