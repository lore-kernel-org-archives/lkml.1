Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbZHMUTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbZHMUTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbZHMUTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:19:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36287 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbZHMUTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:19:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: hibernate causes nobody cared on acpi irq
Date: Thu, 13 Aug 2009 22:20:01 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "Brown, Len" <len.brown@intel.com>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
References: <4A833CAD.5050209@gmail.com> <200908130021.34378.rjw@sisk.pl> <4A846F04.9050005@gmail.com>
In-Reply-To: <4A846F04.9050005@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200908132220.01334.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Jiri Slaby wrote:
> On 08/13/2009 12:21 AM, Rafael J. Wysocki wrote:
> > On Thursday 13 August 2009, Jiri Slaby wrote:
> >> with current mmotm I get this while trying to hibernate from a system in
> >> qemu:
> > 
> > Does it trigger with the "core" test:
> 
> Yes, but I found out it's totally unrelated to the susp code. There is
> an interrupt storm on IRQ9 after system boot -- 150000 intrs on both
> CPUs in the first minute. Then the message emerges.
> 
> It's just a coincidence it appears during hibernation (after interrupts
> enable phase).
> 
> Any idea what it could be?

Well, nothing obvious comes to mind.

Rafael
