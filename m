Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYHCL54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYHCL54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 07:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYHCL5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 07:57:49 -0400
Received: from web52909.mail.re2.yahoo.com ([206.190.49.19]:26537 "HELO
	web52909.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753867AbYHCL5s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 07:57:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=hYoOh9OPrqgzgXQqOqGhd4MY4x/MuApzmNog2fGeSgJHph4JxJvbjCMXIDOSzds9CkR2oGlkDPjRll+XVw5KT0lnuWb5tgTFGdJFS4fbz6jBaKSuEYdVFv33wxI1eyxroLnvg+zr693+anRJHJQS+3DRypftqq+sbLVWUQ63A/s=;
X-Mailer: YahooMailWebService/0.7.218
Date: Sun, 3 Aug 2008 04:57:46 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: rankincj@yahoo.com
Subject: [2.6.26.1] And one very confused mouse!
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <405580.49576.qm@web52909.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have just cold-booted a machine into 2.6.26.1 for the very first time, and for a few seconds I had great difficulty using my PS/2 mouse. Here is what I found in the dmesg log afterwards:

input: PS/2 Generic Mouse as /class/input/input6
psmouse.c: Failed to enable mouse on isa0060/serio1
psmouse.c: Mouse at isa0060/serio1/input0 lost synchronization, throwing 1 bytes away.
psmouse.c: resync failed, issuing reconnect request
psmouse.c: Failed to enable mouse on isa0060/serio1
psmouse.c: Mouse at isa0060/serio1/input0 lost synchronization, throwing 1 bytes away.
psmouse.c: resync failed, issuing reconnect request
input: ImPS/2 Generic Wheel Mouse as /class/input/input7

It seems to have recovered now, but I have never seen this behaviour before and so thought that I should report it. I will monitor this...

Cheers,
Chris



      __________________________________________________________
Not happy with your email address?.
Get the one you really want - millions of new email addresses available now at Yahoo! http://uk.docs.yahoo.com/ymail/new.html
