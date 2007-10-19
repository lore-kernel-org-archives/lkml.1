Return-Path: <linux-kernel-owner+w=401wt.eu-S933069AbXJRXiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbXJRXiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 19:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbXJRXiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 19:38:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:55056 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028AbXJRXiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 19:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=IqJvcobSbGNH0cxIllXbRHajvtUrVjojmsXxh/tEB44FeDMKSErvrCRrW0j9RGn3+MtmvWuAVDJiTD1NVZPmZX8YhdNlDSg63b4rI1OvaFANbmu2TZphuHEq5BFWzp2zr9PGPQZYMEpEuqeNH+Q5CWx/XDa5t3PJNYBlvXX0seg=
Date: Fri, 19 Oct 2007 01:37:36 -0700
To: Russell King <linux@arm.linux.org.uk>
Cc: Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: PDA Suspend SA1100
Message-Id: <20071019013736.11dec046.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I've been trying to implement proper suspend on my jornada 720 machine. But as far as I can see it never reaches
the sa11x0_suspend code.

I've linked power button event to produce APM_SUSPEND and I can see that it says "Stopping TASKS ======". It then
blanks screen but keeps LCD powerd. I know it goes into resume again since removing backlight code in resume function
effectivly turns off the LCD.

Im assuming that it tries to suspend but fails at some point and tries to return into normal operations?
Exactly what is needed to get the suspend procedure happy? Does every driver need to have suspend/resume code?

Best wishes
Kristoffer Ericson
