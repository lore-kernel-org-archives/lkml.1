Return-Path: <linux-kernel-owner+w=401wt.eu-S1752292AbZCXUvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbZCXUvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbZCXUu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:50:59 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:34232 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZCXUu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:50:58 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Mar 2009 16:50:58 EDT
Message-ID: <49C94620.8040309@diamondcut.com.br>
Date: Tue, 24 Mar 2009 17:44:16 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; pt-BR; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: hmh@hmh.eng.br, borislav@users.sf.net
Subject: Thinkpad T61 - Fan running a lot of time
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Anyone have seen fan turned-on in 90% of the time?

I see that fan power-on when processor is up than 45°C and power-off 
when is under 45°C.

Temperature difference between 2 cores is 5°C in idle (Core1=45°C and 
Core2=40°C)

Local temperature is ~25°C, kpowersave is in "dynamic mode", my 2 cores 
(Intel T7500) is running 94% of the time in idle (checked with "top"), 
with clock in 800MHz.

The fan speed is ~2600RPM (always under 3000RPM), and I think that is 
not enough to cooling the processor, because is necessary 3min to 
decrease 1°C in Core1 and only 40sec to increase 1°C.

I think that is necessary a higher fan speed.

I see this in Debian Lenny (2.6.26-1) and 2.6.28.8 kernel... Maybe in 
other versions too.

Regards,
Renato
