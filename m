Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbZFRJT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbZFRJT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 05:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbZFRJTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 05:19:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58922 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754454AbZFRJTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 05:19:19 -0400
Date: Thu, 18 Jun 2009 10:20:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Brian Swetland <swetland@google.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, Robert Love <rlove@google.com>,
       Brian Swetland <swetland@google.com>
Subject: Re: [PATCH 1/3] [ARM] msm_serial: serial driver for MSM7K onboard
 serial peripheral.
Message-ID: <20090618102026.20c54b6a@lxorguk.ukuu.org.uk>
In-Reply-To: <1245285075-20022-2-git-send-email-swetland@google.com>
References: <1245285075-20022-1-git-send-email-swetland@google.com>
	<1245285075-20022-2-git-send-email-swetland@google.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 17:31:13 -0700
Brian Swetland <swetland@google.com> wrote:

> From: Robert Love <rlove@google.com>
> 
> Provides support for the "lowspeed" UARTs on the MSM7k and QSD8k
> family of SoCs from Qualcomm.  Serial console support included.
> 
> Signed-off-by: Robert Love <rlove@google.com>
> Signed-off-by: Brian Swetland <swetland@google.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>

If you fold other peoples patches into something please preserve the
authorship data and preferably keep the two patches separated as it
otherwise causes merge problems if stuff (eg the serial patches) goes via
two trees at once.

At the moment the ttydev tree has
	-> your original -> my (intel's I guess) fixes ->

and if the updated one also went in via the arm tree git can't always
figure out what is going on.

If its only going by one path and you know that then just adding an
additional note on the authorship of updates is fine but this being
serial/tty and ARM is likely to hit both trees.

Alan
