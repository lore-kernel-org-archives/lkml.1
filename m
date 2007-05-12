Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbXELOyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbXELOyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 10:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbXELOyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 10:54:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:47506 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXELOyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 10:54:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XN5oWq9RWl4e0YKiNtJbVpiS1ztyGD9N/7K9O0kvO7RJUjhVhPInpbmKowIpnpC0CmksGZn26Z5brWt/r/uiuQDf/uAggh14Ai3cOfiNpdk27a71ER1op0nnZ4NF5yBJhJsfIp/30eJ4nxEqOQBd3fcfCYVElQxNEu70aiiUZb8=
Message-ID: <38b2ab8a0705120754l281f54eevd1e91e2f01fff6f2@mail.gmail.com>
Date: Sat, 12 May 2007 16:54:10 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: clockevent questions
Cc: tglx@linutronix.de
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to use clocksource and clockevent new subsystem. My
platform has a timer that I'd like to use both as a clocksource and a
clockevent devices. This timer is continueous in sense that it can run
without any interruption so I assume I can flag the clocksource device
with "CLOCK_SOURCE_IS_CONTINUOUS". However I noticed that clockevent
device can be stopped by using "set_mode()" method. Are these two
behaviours compatible ?

Another question is that I have another embedded 16 bits timer that I
would like to use. Since the timer is only 16 bits, the maximum
interval is tiny, My question if a user ask for a clockevent device
using an interval is bigger that 2^16, the clockevent system doesn't
return an error. Instead it silently reduce the interval to 2^16. Is
this correct ? if so why ?

Thanks for your answers
-- 
Francis
