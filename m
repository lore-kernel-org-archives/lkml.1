Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbZAKRL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbZAKRL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 12:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZAKRLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 12:11:50 -0500
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:54757 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZAKRLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 12:11:50 -0500
X-Greylist: delayed 1981 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jan 2009 12:11:49 EST
From: Torsten Schmidt <torsten.schmidt@s2006.tu-chemnitz.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29-rc1
Date: Sun, 11 Jan 2009 17:40:01 +0100
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901111740.01991.schmto@hrz.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: a37c3661e0372786d6c154dc38711565
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, 10 Jan 2009 16:13:02 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> The merge window is over, and while it is quite possible that I missed a 
> few merge requests in the crazy week that is behind us, apart from those 
> we should now have most of the bulk of 2.6.29 merged up. And now it's
> just a small matter of making sure it's all stable and ready to go.
> 

I've got a compiler error in 'drivers/net/irda/donauboe.c':

drivers/net/irda/donauboe.c: In function ‘toshoboe_interrupt’:
drivers/net/irda/donauboe.c:1197: error: ‘struct toshoboe_cb’ has no member 
named ‘stats’
drivers/net/irda/donauboe.c:1201: error: ‘struct toshoboe_cb’ has no member 
named ‘stats’
drivers/net/irda/donauboe.c:1283: error: ‘struct toshoboe_cb’ has no member 
named ‘stats’
make[3]: *** [drivers/net/irda/donauboe.o] Error 1
make[2]: *** [drivers/net/irda] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2



Regards,
Torsten
