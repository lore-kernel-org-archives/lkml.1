Return-Path: <linux-kernel-owner+w=401wt.eu-S1751636AbZGSVno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbZGSVno (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 17:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZGSVnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 17:43:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbZGSVnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 17:43:42 -0400
Date: Sun, 19 Jul 2009 23:43:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Henk Martijn <h.h.martijn@gmail.com>
Cc: jirislaby@gmail.com, jussi.kivilinna@mbnet.fi, tomas.hanak@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Don't hide HID drivers behind EMBEDDED
In-Reply-To: <4A6373C3.7060304@gmail.com>
Message-ID: <alpine.LNX.2.00.0907192341500.11648@wotan.suse.de>
References: <4A6373C3.7060304@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jul 2009, Henk Martijn wrote:

> When trying to minimizing my .config I found that couldn't deselect some 
> HID drivers because they were hidden behind EMBEDDED. What's the reason?

Hi,

mostly this is because we don't want to bother users with asking for every 
single quirky device/vendor, as there are unfortunately a lot of them. 
Usually compiling everything in doesn't waste runtime footprint (the 
modules don't get loaded unless needed), and they don't cost too much disk 
space either.
And if you really want to disable them, CONFIG_EMBEDDED allows you to do 
that.

Please see

	http://lkml.org/lkml/2008/10/14/284

-- 
Jiri Kosina
SUSE Labs
