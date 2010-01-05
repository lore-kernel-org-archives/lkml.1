Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320Ab0AEKo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab0AEKo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 05:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022Ab0AEKoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 05:44:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57489 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753974Ab0AEKoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 05:44:55 -0500
Date: Tue, 5 Jan 2010 10:47:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Breuer <mbreuer@majjas.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tty_io.c  - disassociate_ctty attempted to write to tty = NULL
 question/problem?
Message-ID: <20100105104746.095e5745@lxorguk.ukuu.org.uk>
In-Reply-To: <4B42D297.5010702@majjas.com>
References: <4B42733D.6050704@majjas.com>
	<20100105001205.7e8f131b@lxorguk.ukuu.org.uk>
	<4B42D297.5010702@majjas.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok - thanks - added a WARN_ON(!tty) right after the second call to 
> get_current_tty() in disassociate_ctty()

Thsats a perfectly valid path. Its whatever is doing the write you need
to catch. Having a NULL current tty is perfectly acceptable.

