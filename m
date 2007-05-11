Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbXEKErS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbXEKErS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 00:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXEKErF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 00:47:05 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:13511 "EHLO
	asav10.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbXEKErD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 00:47:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AutRAJmRQ0ZKhRO4W2dsb2JhbACBXI4XHRIRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Remi Colinet <remi.colinet@free.fr>
Subject: Re: Regression in 2.6.21-mm1 (git-input) on Dell D610 laptop
Date: Fri, 11 May 2007 00:47:04 -0400
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1178802325.46431895e9469@imp.free.fr> <20070510185021.c3d28048.akpm@linux-foundation.org>
In-Reply-To: <20070510185021.c3d28048.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705110047.04933.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Remi,

On Thursday 10 May 2007 21:50, Andrew Morton wrote:
> On Thu, 10 May 2007 15:05:25 +0200
> Remi Colinet <remi.colinet@free.fr> wrote:
> 
> > My D610 ALPS Glide Point is unresponsive with 2.6.21-mm1 patch.
> > No problem noticed with 2.6.21.
> > 
> > The culprit seems to be git-input. I have applied 2.6.21-mm1 on top of 2.6.21
> > and then removed git-input patch. It is ok since then.

Have you tried any other -mm? Also, does it help if you stick

	ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);

at the very beginning of psmouse_initialize() in
drivers/input/mouse/psmouse-base.c?

-- 
Dmitry
