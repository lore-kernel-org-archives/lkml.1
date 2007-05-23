Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbXEWSAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbXEWSAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758654AbXEWSAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:00:23 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758607AbXEWSAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:00:21 -0400
Date: Wed, 23 May 2007 11:00:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Renato Golin" <rengolin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH] joydev.c automatic re-calibration
Message-Id: <20070523110013.5ffc4a91.akpm@linux-foundation.org>
In-Reply-To: <d9b9d95f0705221733l46de4262qd9c3f5047c53667@mail.gmail.com>
References: <d9b9d95f0705221733l46de4262qd9c3f5047c53667@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 01:33:14 +0100 "Renato Golin" <rengolin@gmail.com> wrote:

> This small patch adds the automatic recalibration feature without
> spoiling previously calibrated devices. It's a fix for those joysticks
> that report faulty range, specially Saitek Cyborg Evo Force.
> 
> File: drivers/input/joydev.c
> Fix:
>  - extracted code from joydev_connect to method
> joydev_calculate_correction to be able to call it from both
> joydev_event upon recalibration and joydev_connect during first
> connection.
>  - on joydev_connect check ranges and zero calibration if found out of range
>  - on joydev_event, every time found out of range, update min/max and
> recalculate the correction

A few patch protocol things:

- Please always prepare patches in `patch -p1' form

- Include a Signed-off-by: as per Documentation/SubmittingPatches,
  section 11.

- Avoid including two copies of the patch in the one email.  Inlined plain
  text is preferred, ext/plain attachments are grudgingly accepted.

I descrambled the patch, fixed a reject and queued it up in the -mm tree
for Dmitry's consideration, thanks.

