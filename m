Return-Path: <linux-kernel-owner+w=401wt.eu-S1751721AbZLSPPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbZLSPPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 10:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbZLSPPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 10:15:36 -0500
Received: from lo.gmane.org ([80.91.229.12]:53781 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbZLSPPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 10:15:36 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger.hoffstaette@googlemail.com>
Subject: [stable] Regression in 2.6.32.2: segfault on halt
Date: Sat, 19 Dec 2009 16:10:49 +0100
Organization: The Fists of the White Lotus
Message-ID: <pan.2009.12.19.15.10.48.851500@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-135-79.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After updating to 2.6.32.2 last night (using same config from .32.1) I
noticed that "halt" now trips during shutdown and won't power the
machine down any longer. This happens reproducibly on two completely
different machines, so it looks like a generic problem and regression,
since it did not happen in .32.1. Note that "reboot" works as expected -
only "halt" crashes.

Stack dump in two parts (upper/lower half) can be found here:
http://i.imgur.com/hDY8G.png
http://i.imgur.com/bSmUN.png

The topmost line (not captured) said something like "Illegal opcode 00
(CPU #0)".

Let me know if you need anything else. I don't have time for full bisect,
but am willing to try and back out select changesets as long as someone
tells me which ones.. :)

Holger


