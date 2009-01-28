Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZA1HAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZA1HAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 02:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZA1HAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 02:00:08 -0500
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:41987 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbZA1HAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 02:00:07 -0500
Date: Tue, 27 Jan 2009 22:59:59 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Jonathan Campbell <jon@nerdgrounds.com>
cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
In-Reply-To: <497E4531.20800@nerdgrounds.com>
Message-ID: <Pine.LNX.4.64.0901272257460.25242@t2.domain.actdsltmp>
References: <497E4531.20800@nerdgrounds.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009, Jonathan Campbell wrote:
> one, that today's graphics cards have relatively obscene amounts of RAM on 
> them even if you're not using it. If you're running it as a server and not 
> using it for 3D graphics, why not mount the VRAM on the graphics card as a 
> filesystem and store things there to get some extra space?

How fast is it?  For instance, what are your bonnie++ scores for vramfs vs
tmpfs vs something on disk?

It seems like you could at the very least put a swap file on it that's
faster than one on disk.
