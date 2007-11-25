Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbXKYXDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbXKYXDm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 18:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbXKYXDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 18:03:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:3095 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbXKYXDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 18:03:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=Tc+Vr0/rHZkKsfFolN1XoCPwPW9d89iqEoBxiRw5KlnX3+vTHw/knWwzcndqGRmHXCoe66N2BXYyQqcvxLP0vBe2MwZmlJbqONJVo+hZZPnvX5wyodroO7GC5Xh291XOHCd7WRdHMTuY+fwCiSZZISjeCGbIUyPoIa2QWtH4pRs=
Date: Mon, 26 Nov 2007 00:03:29 +0100
To: Dmitry <dmitry.torokhov@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Russell King <linux@arm.linux.org.uk>
Cc: linux-main <linux-kernel@vger.kernel.org>
Subject: Question regarding naming scheme (HP Jornada 6XX/7XX)
Message-Id: <20071126000329.8e7304c5.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Just want some input before I start dropping patches everywhere. A simple ack will do nicely if you just agree.

Currently we use the name of the most typical HP Jornada (680 and 720) to mean all 6XX/7XX (= 620/660/680/690 and 720/720/728). 
In the past this has led to some confusion when people tried to compile their own kernels. 
For instance an hp 620 user thought that their system was unsupported because everything was for '680'. Or the other way round
728 users didn't want to use 720 since they thought they would loose their extra ram (only difference between versions).

So, I want to instead use the term 600-series or 700-series. This would mean changing Kconfig/Makefile and driver name.

For example /drivers/input/keyboard/jornada680_kbd.c would become /drivers/input/keyboard/jornada600_kbd.c

The machine name tag would also return (HP Jornada 600-series | HP Jornada 700-series) since I know for instance opie loves to 
grep the machine line. Currently this is set as "hp6xx" for 600-series and "HP Jornada 720" for 700-series. They are related machines so 
it would be nice to unify their output a tad.

Why I want to use 600-series/700-series instead of 6XX/7XX is simply because 600-series/700-series leaves no doubt.

Any objections?

Best wishes
Kristoffer Ericson

