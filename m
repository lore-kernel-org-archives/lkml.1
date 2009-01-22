Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbZAVGap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbZAVGap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 01:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbZAVGaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 01:30:35 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:30485 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbZAVGae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 01:30:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sgG3hs4u3EYQlVU2+RDDDlRcWDo/0g0HKJBhNXw5iWF0kpwim5AbeaBz1TsvIQUQz5
         7ItiFr3mLoyxlC0ozCirkrvmoCCW3xQ/GkJrF7OJeEKL6LSH1/wfL79BOPOUMSJvaE1S
         GXJ3m94K/Zuc0G98o7J25568VfVv0kQ7Rx8SQ=
Message-ID: <49781251.8070807@gmail.com>
Date: Thu, 22 Jan 2009 11:29:37 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.8.1.19) Gecko/20081226 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Arjan Opmeer <arjan@opmeer.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [Bug #12406] 2.6.28 thinks that my PS/2 mouse is a touchpad
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.HKC.vJRdJB@chimera> <20090120014507.GA1557@adopmeer.homeip.net> <200901200119.59851.dmitry.torokhov@gmail.com>
In-Reply-To: <200901200119.59851.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> Sorry, must have missed that. I think it's gonna be a bit chatty if
> user happens to have Logitech++ device attached, however I think if
> we complement it with the patch below I think it should work OK.

Dmitry, I don't see the effect of your patch. I.e., both the patch by 
Arjan referenced in the bug, and combination of that patch with yours, 
produce a working mouse and this dmesg output:

psmouse serio1: ID: 10 00 64<6>elantech.c: Elantech version query result 
0x00, 0x01, 0x64.
elantech.c: Probably not a real Elantech touchpad. Aborting.
input: ImExPS/2 Logitech Wheel Mouse as /class/input/input18

-- 
Alexander E. Patrakov
