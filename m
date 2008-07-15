Return-Path: <linux-kernel-owner+w=401wt.eu-S1759170AbYGOTyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170AbYGOTyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbYGOTxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:53:53 -0400
Received: from senator.holtmann.net ([87.106.208.187]:33723 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbYGOTxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:53:51 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <200807151757.10626.elendil@planet.nl>
	 <1216149637.27242.65.camel@violet.holtmann.net>
	 <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>
	 <1216150616.27455.377.camel@shinybook.infradead.org>
	 <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 21:54:00 +0200
Message-Id: <1216151640.27242.90.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> Requiring you to write udevd scripts for that sounds insane. I wouldn't 
> even know where to start.
> 
> So kernel-specific directories do make sense. As does the whole "I don't 
> want to handle the pain that is udev scripts".

you don't have to. We extend udev once and then it will always work. As
mentioned before, Ubuntu is already doing this. They never bothered to
submit this upstream and I didn't really care since I have all my
firmware files in /lib/firmware and had no need to add versions to it.

Regards

Marcel


