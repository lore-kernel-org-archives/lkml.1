Return-Path: <linux-kernel-owner+w=401wt.eu-S1752431AbXCHQDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbXCHQDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbXCHQDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:03:10 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52496 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752431AbXCHQDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:03:09 -0500
Date: Thu, 8 Mar 2007 17:07:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: GhePeU <ghepeu@virgilio.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem with libata-pata, ATAPI DVD reader and a
 "copy-protected" audio cd
Message-ID: <20070308170731.458fe407@lxorguk.ukuu.org.uk>
In-Reply-To: <1173360956.24659.3.camel@KazeNoTani>
References: <1172919624.23576.31.camel@KazeNoTani>
	<1173360956.24659.3.camel@KazeNoTani>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, it happened again, with a different cd, and this time I never
> started the player: hal/g-v-m tried to access the CD and now my driver
> is in PIO2 mode and pretty much unusable. Is there a way to fix this
> without rebooting?

Hard to tell. If it happens again then a "dmesg" after it misbehaves and
an lspci -vxx might provide enough information to begin to debug it.

Alan
