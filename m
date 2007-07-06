Return-Path: <linux-kernel-owner+w=401wt.eu-S1763300AbXGFIGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763300AbXGFIGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 04:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760828AbXGFIFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 04:05:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:62584 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760381AbXGFIFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 04:05:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=d5LWrnszfBeXsKGLGXV2m7xxMfH6kNOCdPfmFVFWvzETCmegx9nPbH+pl3Hlq7X+QZcrLr5jJyGaF4QmMKeQ6U3di0qbOwwo0tooMH/Lr/QSPkKvZ/gTR3pz80uxfWMujKqVGSNEzVT1Y8AtnJFlQsIJ4717QR+ai5l5GSnNOs0=
Message-ID: <38b2ab8a0707060105o722c1460lcb422d7899ace53a@mail.gmail.com>
Date: Fri, 6 Jul 2007 10:05:38 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.osdl.org
Subject: Question about pm and tty
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've just finished to implement an input driver for a simple custom
keyboard (only 16 keys).

I wanted to give it a test through a virtual terminal (CONFIG_VT).
Note that I'm not familiar with this at all so pardon me if I'm saying
something silly.

I noticed that as soon as the terminal is initialized, tty_init() is
called, the input device is open and thus its clock is started. It
sounds strange to me, I would have thought that the input device is
open only when /dev/tty is open. Thus the keyboard clock is started
when the keyboard is really used.

Am I missing something ?

Thanks
-- 
Francis
