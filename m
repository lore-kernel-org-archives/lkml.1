Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbXDBFhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbXDBFhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbXDBFhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:37:08 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36257 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbXDBFhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:37:07 -0400
Date: Sun, 1 Apr 2007 22:37:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/16] vt-underline-color.diff
Message-Id: <20070401223701.38127717.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.61.0704012002570.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704012002570.12316@yvahk01.tjqt.qr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007 20:14:14 +0200 (MEST) Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

>  static u8 vgacon_build_attr(struct vc_data *c, u8 color, u8 intensity,
> -			    u8 blink, u8 underline, u8 reverse);
> +			    u8 blink, u8 underline, u8 reverse, u8);

ug.  It's better to include the names of the parameters, IMO.  But mixing
the two styles like this is nuts.

Happily, the declaration is unneeded anyway, so I'll just delete it.
