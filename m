Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbYHSTJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbYHSTJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbYHSTIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:08:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:2421 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbYHSTIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:08:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Wki/TSqR7K/afMylV6MYhgQUm0SHPn4hzJr4qgaT1AMwcdmODYMk6pdfRX3dIHd+cL
         yMRQWbNIkLJErVkUO82RYnzN+qdZthQowPRyZWPM0W2JradQwuUfuBaXj9bXBBPNBWo6
         cMopnPU7bWk6SkUTgx9fl4n+Lnu7VWND9IYvo=
Message-ID: <81b0412b0808191208y6bef9187nc57fa74c08a92d54@mail.gmail.com>
Date: Tue, 19 Aug 2008 21:08:50 +0200
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: rt2500pci: false alarm (was rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed)
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/19 Alex Riesen <raa.lkml@gmail.com>:
> 2008/8/19 Ivo van Doorn <ivdoorn@gmail.com>:
>>> The rt2500 driver in 2.6.27-rc3 (v2.6.27-rc3-552-g3c3a15a) constantly
>>> produces a lot of this messages in log (slowdown quite noticable):
>>>
>>>     kernel: phy0 -> rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed.
>
> It surely did, but I honestly don't remember what with. I'll try to bisect.
>

Ok, it _is_ the hardware. Precisely: it is a dusty box in a dark humid corner.
I reseated the card and suddenly everything started working.

I'm really sorry. The error description was actually a very good
hint at the problem.
