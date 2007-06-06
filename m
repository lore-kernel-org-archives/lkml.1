Return-Path: <linux-kernel-owner+w=401wt.eu-S933454AbXFFEam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbXFFEam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 00:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbXFFEaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 00:30:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55606 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbXFFEae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 00:30:34 -0400
Date: Tue, 5 Jun 2007 21:30:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "young dave" <hidave.darkstar@gmail.com>
Cc: "clameter@sgi.com" <clameter@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [BUG] 2.6.22-rc3-mm1 remove bluetooth usb adapter caused
 kmalloc bug
Message-Id: <20070605213021.7cf4b8ab.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0706052027j25664598tda9b370998e1828@mail.gmail.com>
References: <a8e1da0706051856g242dad96rf4286283192b06c4@mail.gmail.com>
	<20070605194236.03e07a1f.akpm@linux-foundation.org>
	<a8e1da0706052027j25664598tda9b370998e1828@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 03:27:31 +0000 "young dave" <hidave.darkstar@gmail.com> wrote:

> Hi,
> > Are you able to reproduce this in 2.6.22-rc4?
> 
> The bug seems doesn't exist in 2.6.22-rc4, I have tested it, the
> unpluging can't produce kernel bug message.
> 

OK, thanks.  I'll drop bluetooth-postpone-hci_dev-unregistration.patch -
let's see if that helps.

