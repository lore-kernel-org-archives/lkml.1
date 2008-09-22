Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbYIVAOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbYIVAOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 20:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYIVAOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 20:14:36 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:22607 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbYIVAOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 20:14:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=rukwWZlMUZBsQre2x7GNdIsroO+hv2T1VZ1Z+cRoop6dk5xlitgGk77hPYqOlkraqf
         Fs/piwEtj7okpeI/+mfsNn7C570NthQ23Jz85l7Mgl5h9O896DdinHpEofVdTWqz6HYb
         J/FvLhdB2iMxZ2if1TH6Xuieor7eQr8cSUU9Y=
Message-ID: <9e4733910809211714j5d79592cj162f8be4ecebaa78@mail.gmail.com>
Date: Sun, 21 Sep 2008 20:14:34 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: netconsole and a serial one
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have both netconsole and a serial console setup on an embedded
system. This is what I need for the boot process.

After I'm booted I want to turn off printk() output to the serial
console but keep it going to netconsole.
I've been googling for an hour, how do I do this?

I need to turn off the serial output after boot because serial
printk() disables interrupts for up to 1ms which is enough to cause me
to lose a lot of other interrupts.

-- 
Jon Smirl
jonsmirl@gmail.com
