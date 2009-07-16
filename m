Return-Path: <linux-kernel-owner+w=401wt.eu-S933483AbZGPWch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbZGPWch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 18:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbZGPWcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 18:32:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56893 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752718AbZGPWcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 18:32:36 -0400
Date: Thu, 16 Jul 2009 23:33:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 00000004
Message-ID: <20090716233341.19c5aff4@lxorguk.ukuu.org.uk>
In-Reply-To: <dd18b0c30907161530r11b0ff56u12368bc647ba53a@mail.gmail.com>
References: <dd18b0c30907161530r11b0ff56u12368bc647ba53a@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009 15:30:24 -0700
Justin Mattock <justinmattock@gmail.com> wrote:

> Seems This is the first time seeing this.
> steps to recreate(not sure) What I was doing was simple
> exited out of fluxbox(killed the xserver) to read some
> debug messages in bash for a few minuets. Once done
> pressing the powerbutton(which is a simple custom rule:
> shutdown -h now no more no less) resulted in this:
> 
> [22629.384502] BUG: unable to handle kernel NULL pointer dereference at 00000004
> [22629.390005] IP: [<c11aaf5c>] tty_ldisc_wait_idle+0x75/0xcd

Fix went to Linus today


At least I hope it fixed it ;) It did for me
