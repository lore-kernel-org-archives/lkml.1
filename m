Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbYGFLSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbYGFLSa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 07:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYGFLSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 07:18:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbYGFLSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 07:18:20 -0400
Subject: Re: [linux-dvb] [PATCH] Remove fdump tool for av7110 firmware
From: David Woodhouse <dwmw2@infradead.org>
To: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
Cc: linux-dvb@linuxtv.org, kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh <jaswinder@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <48708BBF.9050400@cadsoft.de>
References: <1214139259.2994.8.camel@jaswinder.satnam>
	 <200807060315.51736@orion.escape-edv.de>  <48708BBF.9050400@cadsoft.de>
Content-Type: text/plain
Date: Sun, 06 Jul 2008 12:17:02 +0100
Message-Id: <1215343022.10393.945.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-06 at 11:09 +0200, Klaus Schmidinger wrote:
> On 07/06/08 03:15, Oliver Endriss wrote:
> > Jaswinder Singh wrote:
> >> There's no point in this, since the user can use the BUILTIN_FIRMWARE
> >> option to include arbitrary firmware files directly in the kernel image.
> > 
> > NAK! This option allows to compile the firmware into the _driver_,
> > which is very useful if you want to test various driver/firmware
> > combinations. Having the firmware in the _kernel_ does not help!
> 
> I strongly support Oliver's request!
> Working with various driver versions is much easier with the
> firmware compiled into the driver!

That's strange; I've found exactly the opposite to be the case. 

If I want to test permutations of driver and firmware, as I've done for
the libertas driver a number of times, I find it _much_ better to
preserve the modularity. I can build each version of the driver and can
test that against various firmware versions without having to rebuild
it, and with much less chance of something going wrong so that I'm not
actually testing what I think I'm testing.

Perhaps I'm missing something that would help me work better? Please
could you help me understand how you currently work, and I'll attempt to
make it easier for you. Can you talk me through an example of a session
where you had to do this testing of 'various driver/firmware
combinations'?


-- 
dwmw2

