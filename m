Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbZFOIwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbZFOIwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZFOIvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:51:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43125 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751165AbZFOIvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:51:52 -0400
Date: Mon, 15 Jun 2009 09:52:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Brian Swetland <swetland@google.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, Robert Love <rlove@google.com>,
       Brian Swetland <swetland@google.com>
Subject: Re: [PATCH 1/3] [ARM] msm_serial: serial driver for MSM7K onboard
 serial peripheral.
Message-ID: <20090615095259.3456de5c@lxorguk.ukuu.org.uk>
In-Reply-To: <1245033557-10968-2-git-send-email-swetland@google.com>
References: <1245033557-10968-1-git-send-email-swetland@google.com>
	<1245033557-10968-2-git-send-email-swetland@google.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009 19:39:15 -0700
Brian Swetland <swetland@google.com> wrote:

> From: Robert Love <rlove@google.com>
> 
> Signed-off-by: Brian Swetland <swetland@google.com>

The set_termios method also needs to properly propogate back the settings
it actually used (in your case thats mostly the setting the actual speed
selected).

The locking on port.tty also wants looking at but thats a general
drivers/serial project.
