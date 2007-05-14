Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbXENMeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbXENMeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 08:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbXENMei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 08:34:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55727 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXENMeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 08:34:37 -0400
Date: Mon, 14 May 2007 13:34:36 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [RFC][PATCH] Make prepare_namespace() wait for devices
Message-ID: <20070514123436.GB4095@ftp.linux.org.uk>
References: <464853D9.70904@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464853D9.70904@drzeus.cx>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 02:19:37PM +0200, Pierre Ossman wrote:

First of all, please do not put patches in attachments.

As for the patch, an infinite loop is *much* worse than a panic.
When one is installing a new kernel on remote box, having it
booted with reboot on panic and loader falling back to old
kernel on the next boot is a bloody good idea - gives you extra
safety.  With your patch it will get the box stuck.
