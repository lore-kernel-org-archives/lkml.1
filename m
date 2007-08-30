Return-Path: <linux-kernel-owner+w=401wt.eu-S1762175AbXH3Bvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762175AbXH3Bvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 21:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbXH3Bvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 21:51:38 -0400
Received: from max.aladin.ro ([80.96.155.2]:56946 "EHLO aladin.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046AbXH3Bvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 21:51:37 -0400
Message-ID: <46D622A5.2000205@aladin.ro>
Date: Thu, 30 Aug 2007 04:51:33 +0300
From: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Forced unmounting for removable devices
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

*This message was transferred with a trial version of CommuniGate(r) Pro*
This might have been discussed a few years ago, but things have changed. 
I'm talking about patches like this one (I'm not the author): 
http://developer.osdl.org/dev/fumount/#kernel1

The current situation requires a way to forcibly unmount removable 
media. Consider the following (real) scenario. Someone has a box with 
hald + dbus + ivman to support "supermounting" the CDROM drive. He has 
to install a 2 CD application using Wine for example, but the setup 
application prevents normal unmounting of the first one. Then he goes on 
and pushes the button to eject the CD, lazy-unmounting the media. The 
kernel goes mad and all attempts to load the second CD fail (the kernel 
hasn't got rid of the first fs).

If there was anything like a real forced unmounting, things would have 
worked well, as on MS Windows itself.

As far as I can see, there is no other sane way to solve such problems. 
So, what's keeping such patches from making their way into the 
mainstream kernel? All (but maybe I haven't searched enough) arguments 
against such a feature that I've seen by now just say "it's not needed", 
"it's not worth it" and so on, and many of them refer to network mounts.

P.S.: I'm not saying lazy unmounting should be replaced. They both make 
sense, depending on the scenario.
