Return-Path: <linux-kernel-owner+w=401wt.eu-S1752074AbZIHR7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbZIHR7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZIHR7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:59:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60120 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751922AbZIHR65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:58:57 -0400
Date: Tue, 8 Sep 2009 18:59:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] char/tty_io: fix legacy pty name when more than 256
 pty devices are requested
Message-ID: <20090908185926.042ba9aa@lxorguk.ukuu.org.uk>
In-Reply-To: <20090908144942.76ddf0e7@caramujo.chehab.org>
References: <20090908144942.76ddf0e7@caramujo.chehab.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, in order to allow more pty devices, the nomenclature were extended for
> the devices with minor 256 or above. For those, the nomenclature will be:
> 	ttyf0000-ttfpffff	(pty slave)
> 	ptyf0000-ttyfffff	(pty master)
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

This fine and the namespace is free - but you need to update
Documentation/devices.txt as well please.


Alan
