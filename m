Return-Path: <linux-kernel-owner+w=401wt.eu-S1751886AbYJRMw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbYJRMw2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 08:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYJRMwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 08:52:20 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:10141 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYJRMwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 08:52:19 -0400
Message-ID: <f488382f0810180552w2078244eiaed1fa100ad4c4c6@mail.gmail.com>
Date: Sat, 18 Oct 2008 05:52:18 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "kernel list" <linux-kernel@vger.kernel.org>, anders@anduras.de
Subject: appletouch regression
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that the appletouch driver is (sporadically) not detecting my
Apple Trackpad anymore on Linus' current tree (2.6.27-05577-g0cfd810).
When it is misbehaving, it doesn't have any /dev/input/event* entry
that corresponds to the input from appletouch, and dmesg -should- show
the following, as 2.6.27.1 does, but does not:

appletouch: Geyser mode initialized.
input: appletouch as /class/input/input4
usbcore: registered new interface driver appletouch
appletouch: 17" model detected

On the current tree, occasionally all I get is:

usbcore: registered new interface driver appletouch

It's unfortunately a touchy issue, as it only -occasionally- happens.
A bisection will be a pain in the butt, but I'm starting it right now
anyway.

- Steven
