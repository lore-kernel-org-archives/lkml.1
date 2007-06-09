Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbXFINjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbXFINjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 09:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbXFINjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 09:39:31 -0400
Received: from smtp3.nextra.sk ([195.168.1.142]:3365 "EHLO mailhub3.nextra.sk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756676AbXFINjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 09:39:31 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Ralph Corderoy <ralph@inputplus.co.uk>
Subject: Re: How to get an IDE Hard Reset, not a Soft Reset?
Date: Sat, 9 Jun 2007 15:40:19 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20070609131031.CBB5014A521@blake.inputplus.co.uk>
In-Reply-To: <20070609131031.CBB5014A521@blake.inputplus.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706091540.19661.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 June 2007 15:10:31 Ralph Corderoy wrote:
> Hi,
>
> As I understand it, an IDE hard drive can be reset in three ways.  A
> power-on reset, a hard reset caused by pin 1 (RESET-) on the IDE
> connector, and a soft reset (bit SRST in the device control register).
> RESET- is held low on a power on, but can also be used later to do a
> hard reset.

The RESET pin is often wired to the system RESET signal, so there is no way to 
control it separately.

-- 
Ondrej Zary
