Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYGHJp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYGHJp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 05:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYGHJpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 05:45:20 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:53777 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYGHJpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 05:45:19 -0400
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Date: Tue, 8 Jul 2008 11:45:17 +0200
User-Agent: KMail/1.9.9
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de> <200807072308.57529.IvDoorn@gmail.com> <200807072323.09177.stefan.bauer@cs.tu-chemnitz.de>
In-Reply-To: <200807072323.09177.stefan.bauer@cs.tu-chemnitz.de>
Organization: Chemnitz University of Technology
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081145.17281.stefan.bauer@cs.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 8a8fa125b9cc748093f12ed7809f170b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 7. Juli 2008 schrieb Stefan Bauer:
> On Monday 07 July 2008 23:08:57 Ivo van Doorn wrote:
> > Check if the arc4 and ecb modules are loaded before loading mac80211 &
> > rt2500pci.
>
> They weren't, but loading them before doesn't make any difference.

I've checked this again. If I unload all wireless stuff, then modprobe *every* 
module in .../kernel/crypto/ it works. Both 2.6.24.7 and 2.6.26-rc9 load the 
driver and create an interface.
(2.6.24.7 isn't able to iwlist scan or associate, but that seems to be an old 
fixed issue.)

So it seems to me it isn't really a bug, more likely kind of inconvenience.


Again thanks for your help!
Stefan
