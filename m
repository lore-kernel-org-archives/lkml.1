Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbXGOJgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbXGOJgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 05:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbXGOJgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 05:36:24 -0400
Received: from smtp.qwerty.ru ([87.240.2.134]:57984 "EHLO smtp.qwerty.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbXGOJgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 05:36:23 -0400
Date: Sun, 15 Jul 2007 13:36:22 +0400
From: Kirill Kuvaldin <kuvkir@epsmu.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isofs: mounting to regular file may succeed
Message-ID: <20070715093622.GB17652@zetta.epsmu.com>
References: <20070713234721.GG4536@zetta.epsmu.com> <Pine.LNX.4.64.0707142115370.25352@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707142115370.25352@fbirervta.pbzchgretzou.qr>
Organization: EpsMu Inc.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2007 at 09:16:51PM +0200, Jan Engelhardt wrote:
> 
> On Jul 14 2007 03:47, Kirill Kuvaldin wrote:
> >
> >We then can mount it to a regular file:
> 
> Wow, this is news to me. Since when is it possible to mount files to files?
> 

It is possible to mount a regular file to another one with --bind.
The problem in question is that mounting a malformed ISO 9660 image to a
directory fails, but to a regular file - succeeds.

Kirill
