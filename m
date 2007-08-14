Return-Path: <linux-kernel-owner+w=401wt.eu-S1765591AbXHNRhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765591AbXHNRhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758173AbXHNRhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:37:34 -0400
Received: from server1.secure-linux-server.com ([207.44.172.97]:55213 "EHLO
	dbamsoftware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbXHNRhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:37:34 -0400
X-Greylist: delayed 3719 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2007 13:37:33 EDT
Message-ID: <46C1D9CB.9040208@ufomechanic.net>
Date: Tue, 14 Aug 2007 17:35:23 +0100
From: Amin Azez <azez@ufomechanic.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jesse.brandeburg@gmail.com, me@privacy.net,
       hpa@zytor.com
Subject: Re: Intel 82559 NIC corrupted EEPROM 
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Regarding the thread accessible at:
   
http://groups.google.com/group/linux.kernel/browse_frm/thread/bdc8fd08fb601c26

that ended with "looks like it is specific to your hardware",

Can I check where we are with this?

I've just had a small installation run fail on 3 boxes with the same
problems, on new hardware, which sort of suggests there is no longer a
shortage of test scenarios.

To summarise, in my case it looks as though it really was a bad
checksum, by using the eepro100 driver and the lucky-fortune eeprom tool
at http://www.hockin.org/~thockin/enet_eeprom/enet_eeprom.tgz I was able
to re-write the mac address and thus have the EEPROM checksum re-calculated.

I don't recall the original reporter (John) saying that he had tried this.

I'm still checking with my supplier to see how this could have happened.

Sam
