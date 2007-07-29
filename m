Return-Path: <linux-kernel-owner+w=401wt.eu-S932323AbXG2SFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbXG2SFr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 14:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765678AbXG2SFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 14:05:25 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:63071 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765229AbXG2SFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 14:05:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ji77rGgg5tqexZoIY3aDIQnMzmIGBm/G+fYzOStbc/3MjHYg1oZ1zWAQr3+GCg/SwuOIMZvewljiN16beSWWoZ1O4MZSI5pi8xCs8s90AfJ71ik+/oq1Jw/INtQaNOl83MAB+A/95LclOV3f1QE7ZQqmJKZrt60ADdkq2USm0yU=
Message-ID: <5ebbd9b50707291105w316f98e5h3fa17204c9119a2f@mail.gmail.com>
Date: Sun, 29 Jul 2007 18:05:21 +0000
From: "Frank Hale" <frankhale@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: ACPI on Averatec 2370
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have an Averatec 2370 laptop with the nVidia MCP51. With kernel
2.6.20 I had no issues with ACPI however with 2.6.21 and higher the
kernel will hang on boot until I press the suspend button or the power
button in which case the kernel wakes up and finishes the boot
process. Including the following support only causes the issue:

 [*] ACPI Support

What I mean by that is every ACPI option has been deactivated and only
ACPI support checked. The boot process with 2.6.21 and higher hangs at
the point where the Scheduler is being registered.

io scheduler cfq registered (default)

If I allow it to sit there it never comes back to life and finishes
booting. If I press the power or suspend button it will finish booting
as expected.

I've scoured google for quite a while but cannot find any relevant
information pertaining to this issue. For now I've disabled ACPI
altogether.
