Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbXKYRoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbXKYRoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 12:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXKYRoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 12:44:14 -0500
Received: from srv02.itamservices.de ([87.106.7.29]:49512 "EHLO
	itamservices.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbXKYRoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:44:13 -0500
Message-ID: <4749B469.5070406@itamservices.de>
Date: Sun, 25 Nov 2007 18:44:09 +0100
From: Daniel Reichelt <mail@itamservices.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Patch: Hide process info from other users/users not in my group
References: <4742B82C.3060001@itamservices.de> <20071121180338.GB3888@ucw.cz>
In-Reply-To: <20071121180338.GB3888@ucw.cz>
X-Enigmail-Version: 0.95.0
OpenPGP: id=360C6B0F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> This really needs to be runtime-configurable.
Hm. When this setting is changed during runtime, all the pre-existing
permissions would have to be changed as weill which might be done by iterating
through a list of running processes. Unfortunately I don't know how to do that.
This is my very first kernel patch (ever) and if I'd try to code s.th. like
that, I'd probably conjure race-conditions and other beasts... If you're
willing to help me, we might come up with a solution...

cu
Daniel
