Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbYJaSsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbYJaSsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 14:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYJaSsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 14:48:13 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:42378 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYJaSsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:48:12 -0400
Date: Fri, 31 Oct 2008 16:48:59 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: "Nick Kossifidis" <mickflemm@gmail.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, willy@linux.intel.com,
       lrodriguez@atheros.com
Subject: Re: ath5k gets lost with eeepc-laptop removal
Message-ID: <20081031164859.7808de23@doriath.conectiva>
In-Reply-To: <20081031164351.3e4a9d4e@doriath.conectiva>
References: <20081031110502.18e33eba@doriath.conectiva>
	<40f31dec0810310926p6edd0af5o24d7616eb54c6d0@mail.gmail.com>
	<20081031151901.2d68c32d@doriath.conectiva>
	<40f31dec0810311133v65001e59h28cf6946ac3f14e7@mail.gmail.com>
	<20081031164351.3e4a9d4e@doriath.conectiva>
Organization: Mandriva
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 31 Oct 2008 16:43:51 -0200
"Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br> escreveu:

| Em Fri, 31 Oct 2008 20:33:43 +0200
| "Nick Kossifidis" <mickflemm@gmail.com> escreveu:
| 
| | 2008/10/31 Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>:
| | >
| | >  No, it doesn't. It says:
| | >
| | > """
| | > MAC revision 0xffff is not supported!
| | > """
| | >
| | >  And I have realized that I get a flood of 'failed to wakeup'
| | > and 'can't reset the hardware' error messages, just some seconds
| | > after the eeepc-laptop module removal.
| | >
| | 
| | Well it seems that during module removal, card gets no power at all.
| | I don't see any reason for this behaviour. Do you have pci-e hotplug enabled ?
| 
|  Well, the pciehp module is not loaded and the eeepc's function keys
| don't work anyway (this is the original problem I was looking at).

 Hmm. You think this could be related, Matthew?

 Actually 'they don't work' is not helpful, I have been looking at
the wireless one (fn2) which doesn't even turn the led off but the
driver seems to receive the event.

-- 
Luiz Fernando N. Capitulino
