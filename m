Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722Ab0AZQuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0AZQuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 11:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474Ab0AZQuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 11:50:10 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:39340 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab0AZQuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 11:50:04 -0500
Message-ID: <3026aa4769d53c108ee0671f2b17c668.squirrel@intranet.cs.nmsu.edu>
Date: Tue, 26 Jan 2010 09:50:02 -0700
Subject: usbhid driver: replacing resume or using a post resume function
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Linux" <linux-kernel@vger.kernel.org>,
       "Linux USB" <linux-usb@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking for an example of a hid driver that needs to customize
resume or provides a post resume function, but couldn't find one.

I would like to implement some post resume code. In particular, the g13 on
resume loses the backlight color, LCD image and LED state. On resume, it
needs feature reports sent to re-establish these settings.

However, I couldn't find a way to either provide a post resume function or
replace resume with a call to hid_resume() followed by the feature
reports.

Any suggestions?

---

Rick


