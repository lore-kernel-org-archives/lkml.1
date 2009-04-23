Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbZDWVHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbZDWVHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758458AbZDWVGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:06:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40445 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758759AbZDWVGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:06:51 -0400
Date: Thu, 23 Apr 2009 22:06:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anatolij Gustschin <agust@denx.de>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] Add CONFIG_FB_PRE_INIT_FB option to VT and fbcon
Message-ID: <20090423220622.313090a1@lxorguk.ukuu.org.uk>
In-Reply-To: <20090423134952.5328923a.akpm@linux-foundation.org>
References: <1240348380-15674-1-git-send-email-agust@denx.de>
	<20090423134952.5328923a.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks to be a complete mess. It puts a large pile of ifdefs all over
core kernel code for a single hack specific to one environment.

If you don't want the vt layer using the frame buffer then don't use the
vt layer.

Alan
