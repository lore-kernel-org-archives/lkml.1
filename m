Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbXEIVPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbXEIVPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbXEIVPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:15:45 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:15083 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbXEIVPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:15:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pEkC/SZRZ3SXMQB6EeSovtEr2Bu8n2HkGKM4tyzS3V76diaSJU9/+LuTjrBHHyiqSeoxtaFAlvWJIdHkKw66HViCriVG4K3KrPhF/pPulEyx4MbVLwCiZKDphe7W2mBVovRg/k9j/upbk55aI1C3N0yi/nhYI9DYJ3G6PCkZFWc=
Message-ID: <8d6898730705091415s74685223r4c4409e87ff587c@mail.gmail.com>
Date: Thu, 10 May 2007 02:45:42 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: alsa-devel@alsa-project.org
Subject: Mic and Line In Capture AC97 slots issue
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

http://mailman.alsa-project.org/pipermail/alsa-devel/2007-May/000835.html
http://mailman.alsa-project.org/pipermail/alsa-devel/2007-May/000837.html

the overrun  issue was because my application was not fast enough.

I resolved that problem by disabling capture of AC-Link slot4 in my
ac97 controller.
So capture happens only in slot3.

According to ac97 spec Mic comes in Slot6 of AC-Link.

I am using wolfson wm9713 codec.

In this LineR and LineL are routed to LeftADC and RightADC.

And Mic1 (Mic A) is also coonected to LeftADC and RightADC.


So i am assuming that Mic 1 will come in Slot3 and Slot4.

But my application is taking only mono data, so XRUN will happen.


What is the correct configuration for this?
What should be the configuration if i want to capture both Line IN and Mic?
means AC-Link settings

Thanks
