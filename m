Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYIRODb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYIRODb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 10:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYIRODY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 10:03:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37247 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbYIRODX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 10:03:23 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Thu, 18 Sep 2008 10:00:35 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: Janne Grunau <j@jannau.net>, Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Erik Hovland <erik@hovland.org>
References: <200809112149.25762.stefan.bauer@cs.tu-chemnitz.de> <200809151420.32130.jwilson@redhat.com> <200809160008.43218.jwilson@redhat.com>
In-Reply-To: <200809160008.43218.jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809181000.35810.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 September 2008 00:08:43 Jarod Wilson wrote:
> Current git tree works for receiving IR signals via lirc_serial (tested by
> Janne) and via lirc_mceusb2 (tested by me). Something is still slightly
> haywire with lirc_i2c though. It registers fine, but IR signals simply
> aren't making it to lircd. Probably unrelated to the dynamic device num
> changes, looking into it.

Despite compiling fine w/o #include'ing linux/i2c-algo-bit.h and coverity 
apparently thinking its not needed, its really quite necessary for things to 
function. Restored it, and lirc_i2c now works again.

-- 
Jarod Wilson
jarod@redhat.com

