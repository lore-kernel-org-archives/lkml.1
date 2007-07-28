Return-Path: <linux-kernel-owner+w=401wt.eu-S1764298AbXG1LoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764298AbXG1LoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 07:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbXG1LoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 07:44:00 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45918 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbXG1Ln7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 07:43:59 -0400
Date: Sat, 28 Jul 2007 13:43:58 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bernd Petrovitsch <bernd@firmix.at>
cc: beck0778@umn.edu, linux-kernel@vger.kernel.org
Subject: Re: How to register block device as read-only
In-Reply-To: <1185622574.3655.11.camel@gimli.at.home>
Message-ID: <Pine.LNX.4.64.0707281343140.15125@fbirervta.pbzchgretzou.qr>
References: <Prayer.1.0.16.0707271307310.28071@wm1.tc.umn.edu>
 <1185622574.3655.11.camel@gimli.at.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 28 2007 13:36, Bernd Petrovitsch wrote:
>
>Unless I misunderstand the question, the "write" and "writev" function
>of the "struct file_operations" should return an appropriate error value
>(which is here -EACCES).
>You may think of returning an error in the "open" if someone wants to
>open it to write to it (so that the must open it read-only).
>But I don't know if that is common practice or not (or even disliked) as
>it may interfere with not properly implemented tools which open devices
>read-write even if they never write to it.

Yes it is, I believe. When mount(8) gets an error from mount(2),
it retries with MS_RDONLY enabled.


	Jan
-- 
