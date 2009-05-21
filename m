Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbZEUQnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbZEUQnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZEUQnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:43:22 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:65526 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbZEUQnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:43:20 -0400
MIME-Version: 1.0
In-Reply-To: <4A1565B6.10907@s5r6.in-berlin.de>
References: <tkrat.21c425cc195510c9@s5r6.in-berlin.de> <20090521134856.GA3457@psychotron.englab.brq.redhat.com> 
	<4A1565B6.10907@s5r6.in-berlin.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 21 May 2009 18:43:01 +0200
Message-ID: <ac3eb2510905210943h109e6cc6o76e9978fe47a6eac@mail.gmail.com>
Subject: Re: [PATCH] ieee1394: eth1394: use "firewire%d" instead of "eth%d" as 
	interface name
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jiri Pirko <jpirko@redhat.com>, linux1394-devel@lists.sourceforge.net,
       linux-hotplug@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jay Fenlason <fenlason@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 16:31, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Usually I prefer brevity too.  Alas, it may not be clear to many people what
> "fw" is supposed to mean.  People might associate it with, let's say,
> "firewall" before "firewire" when they deal with networking. However, more
>  opinions on this are welcome.

Yeah, common one is also "firmware". I think "firewire" is fine.

> As for practical length restrictions:  The kernel's networking core requires
> that these names fit into 15 characters plus trailing \0.  I don't have an
> idea whether there are userland components which have even tighter
> restrictions.
>
> Does anybody know of potential trouble in networking tools if interface
> names are 9 or 10 characters long?

I don't think so, stuff at the tools level usually works flawlessly
with "eth0_rename_ren" devices, when things went wrong with renaming
the devices. :)

Kay
