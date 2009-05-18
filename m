Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbZERJt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbZERJt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757976AbZERJem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:34:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57502 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757994AbZERJel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:34:41 -0400
Date: Mon, 18 May 2009 10:35:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrea <andrea256it@yahoo.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: super root shell/mode/api
Message-ID: <20090518103545.6603b08e@lxorguk.ukuu.org.uk>
In-Reply-To: <861928.62033.qm@web23602.mail.ird.yahoo.com>
References: <861928.62033.qm@web23602.mail.ird.yahoo.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some days ago I've lost some important data on a Linux
> machine, because of an out of memory and swap situation.
> 
> When I was coding on c-64 and it crashes I pressed my
> Cartridge button and could save what I wanted, execute
> code and so on. Some may remember this old school times :)
> 
> Now 20 years has passed and a web page can block my whole
> machine?!?!?!?

Your distribution failed to configure your system sensibly in that case.
Linux has supported a strict overcommit mode for some years, and in that
mode a process isn't permitted to drive the system so far out of memory
it locks up or hangs.

You can also set some limits on a given process (which with certain
versions of firefox - especially old ones or if you have the flash plugin
is a good idea).

First call  - ask your distribution why it isn't using strict overcommit.
