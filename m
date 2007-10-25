Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbXJYMap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbXJYMap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 08:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbXJYMai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 08:30:38 -0400
Received: from smtp1.int-evry.fr ([157.159.10.44]:57936 "EHLO
	smtp1.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXJYMah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 08:30:37 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/4 resend] [x86] Add generic GPIO support to x86
Date: Thu, 25 Oct 2007 14:30:02 +0200
User-Agent: KMail/1.9.7
Cc: Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org
References: <200710181551.24912.florian.fainelli@telecomint.eu> <20071022151845.5874fba3@ephemeral> <alpine.LFD.0.9999.0710251013170.3186@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710251013170.3186@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710251430.03202.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le jeudi 25 octobre 2007, Thomas Gleixner a écrit :
> It might be useful for everyone to check, whether the existing GPIO
> functionality can be extended, reworked to match the needs of Geode as
> well. Extending / reworking an existing interface is definitely
> better than adding a new incompatible one.

Of course. Just because Geode is the only x86 potential user of such an API 
does not mean it should impose its design. Remember that this patch is part 
of a serie to add support for the RDC R-321x SoC, which becomes another 
x86-family user.

Looking at what Geode can do, and what RDC can do, I guess there are only few 
functions that are generic, all the drain, multiplexing, direction things are 
only available on the Geode board.
------------------------------
