Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbYD2GyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbYD2GyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbYD2GyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:54:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:1704 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbYD2GyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=rSQGMKF1BD5fqeKC2Dmd3klHnwtc4ORfFCp1MjuE4vV7Xo6kJopKJBho+k6TlVjLTNbmHhLNmaoPSAlE8nFmcwaBELlR17OI8ufuYk8JBdhaoho3uI/KC1rcAEzfSYF/4xU1aZUFHzBD2hJGLzic/UCDB+74uV3H9n9EZrjDzgI=
Message-ID: <4816C605.4000601@gmail.com>
Date: Tue, 29 Apr 2008 07:53:57 +0100
From: Richard <tuxbox.guru@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: 2.6.25 pci=noacpi
References: <20080425183807.366134771@ldl.fc.hp.com> <20080425183934.516655076@ldl.fc.hp.com> <4813B5AB.4060308@keyaccess.nl> <200804281507.38309.bjorn.helgaas@hp.com>
In-Reply-To: <200804281507.38309.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Using an AMD Sempron notebook (HP Compaq 6715b) single processor 
machine,  It shuts down during bootup when ACPI is fully enabled.  I 
added pci=noacpi to the cmdline and it finally boots, but its extremely 
slow...  (kdm times out with error saying it took too long to load and 
disables graphical)

Dmesg doest show anything out of the ordinary, irq_stats only shows the 
timer interrupts being incremented. (noirq also works, but same 
behaviour) Can someone please offer me some pointers so I can fault find 
this problem.

Thanks in advance
Richard
