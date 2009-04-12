Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbZDLBJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbZDLBJT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 21:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZDLBJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 21:09:03 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:61376 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbZDLBJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 21:09:02 -0400
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Apr 2009 21:09:02 EDT
Message-ID: <49E13D18.2090805@solemnwarning.net>
Date: Sun, 12 Apr 2009 02:00:08 +0100
From: Daniel Collins <solemnwarning@solemnwarning.no-ip.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.28 /proc/diskstats
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.0 c=1 a=XJ15EOvitzOTC7ylOCsA:9 a=nATSeZ188XZaqagP6QnG4CKKOVkA:4 a=50e4U0PicR4A:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Since 2.6.28, fd0 isn't visible in /proc/diskstats from boot, only after 
access/mount. It is visible in /sys/block/ from boot, so there are no 
issues detecting it. This may also affect other devices such as hda but 
I haven't tested this yet, my test system and QEMU both only have 
ram0-ram15 from boot. I have tested 2.6.30-rc1 and found the same 
behavior. Is this a bug or a deliberate change?

Thanks

