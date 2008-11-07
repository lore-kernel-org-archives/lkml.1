Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYKHAAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYKHAAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 19:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYKGX75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:59:57 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:58202 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbYKGX74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:59:56 -0500
Date: Sat, 8 Nov 2008 00:59:50 +0100
From: "Udo A. Steinberg" <udo@hypervisor.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: UART loses characters
Message-ID: <20081108005950.56fe267e@laptop.hypervisor.org>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The serial connection of my T61 loses characters. Specifically when doing
something like:

cat somelargetextfile > /dev/ttyS0

I'm seeing the first characters of the file on the other side of the serial
line and then output stops. Transmission of characters resumes when keys are
pressed on the sender side or the trackpoint is moved. This seems to
indicate some interrupt problems on the sender side. I'm running 2.6.27 but
older 2.6. kernels show the same symptoms.

Any ideas how this can be debugged further?

Cheers,

	- Udo
