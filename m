Return-Path: <linux-kernel-owner+w=401wt.eu-S1763506AbXFCEsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763506AbXFCEsw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 00:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbXFCEso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 00:48:44 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:42515 "EHLO
	asav11.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbXFCEsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 00:48:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah5FAKDkYUZKhRO4UGdsb2JhbACHM4hGAQEbExEB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Add INPUT support to toshiba_acpi
Date: Sun, 3 Jun 2007 00:48:39 -0400
User-Agent: KMail/1.9.3
Cc: Richard Hughes <hughsient@gmail.com>, Bastien Nocera <hadess@hadess.net>,
       John Belmonte <john@neggie.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
References: <1180614979.2693.26.camel@localhost.localdomain> <1180788652.2355.27.camel@localhost.localdomain> <20070602142333.GA3452@srcf.ucam.org>
In-Reply-To: <20070602142333.GA3452@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706030048.40393.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 June 2007 10:23, Matthew Garrett wrote:
> On Sat, Jun 02, 2007 at 01:50:52PM +0100, Richard Hughes wrote:
> > > KEY_SCREENLOCK? KEY_SCREENSAVER?
> > 
> > Either of these keys would be good to add.
> 
> We've been interpreting "KEY_COFFEE" as screenlock (as in "I've gone for 
> a coffee break, lock the screen").
> 

It looks like KEY_COFFE comes from 0x0c/0x19e - AL Terminal Lock/Screensaver
so your interpretation is indeed correct. I guess I better add an alias to
input.h

-- 
Dmitry
