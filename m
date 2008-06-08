Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYFHVKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYFHVKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 17:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbYFHVKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 17:10:24 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:55709 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755052AbYFHVKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 17:10:23 -0400
X-Greylist: delayed 1747 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jun 2008 17:10:19 EDT
Date: Sun, 8 Jun 2008 22:41:08 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Sven Schnelle <svens@stackframe.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] macb: use random mac if stored address in EEPROM is
 invalid
Message-ID: <20080608224108.1f73f219@siona.local>
In-Reply-To: <87wsl56qob.fsf@apollo.stackframe.org>
References: <87wsl56qob.fsf@apollo.stackframe.org>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jun 2008 19:44:20 +0200
Sven Schnelle <svens@stackframe.org> wrote:

> We should use a random mac address if the EEPROM doesn't contain a valid
> one. This makes life on Boards with unprogrammed EEPROM devices easier.
> 
> Signed-off-by: Sven Schnelle <svens@stackframe.org>

Hmm. I don't know. How common is this on properly configured boards?

Btw, the macb driver doesn't read any EEPROM. It reads the hardware
registers of the controller because ARM for some bizarre reason insists
on the boot loader passing the MAC address through hardware registers
(despite the fact that the maintainer of the boot loader insists on
_not_ doing that.)

But if assigning a random mac address when a real mac address isn't
available is common practice in netdev-land, I guess this patch fine
with me.

Haavard
