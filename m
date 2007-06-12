Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbXFLN3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbXFLN3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbXFLN3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:29:44 -0400
Received: from host.infinivid.com ([64.119.179.76]:33397 "EHLO
	host.infinivid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbXFLN3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:29:43 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jun 2007 09:29:43 EDT
Subject: allocation failed: out of vmalloc space - use vmalloc=<size> to
	increase size.
From: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 09:22:43 -0400
Message-Id: <1181654569.8164.14.camel@microwave.infinitevideocorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am writing a linux kernel driver for a custom pci device. I am
developing against the stock fedora 6 kernel on an x86. This device has
512 MB of IO memory reserved by BAR 3. Whenever I try to ioremap this
space I get the error:

allocation failed: out of vmalloc space - use vmalloc=<size> to increase
size.

I think I understand why this is happening. I obviously don't have
enough vmalloc space to map such a large chunk of memory. I have been
using Corbet's et el's "Linux Device Drivers", Love's "Linux Kernel
Development", and many websites as a guide in this development process
but have yet to come across information that will help me.

I'm curious if there is a way around this issue. Or a better way of
handling it so that I can properly map the entire io memory space.


Thanks for any help,
Jon

