Return-Path: <linux-kernel-owner+w=401wt.eu-S1031578AbXEAHRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031578AbXEAHRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 03:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031580AbXEAHRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 03:17:13 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:33331 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031578AbXEAHRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 03:17:12 -0400
Message-ID: <4636E970.3010602@interia.pl>
Date: Tue, 01 May 2007 09:17:04 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Natsemi DP83815 driver spaming
References: <46365887.3010705@interia.pl> <20070430205522.abad2481.akpm@linux-foundation.org>
In-Reply-To: <20070430205522.abad2481.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EMID: 2208acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
>> [...]
> 
> It seems to be repeatedly setting the same duplex setting.  The closest
> thing I can see in there in recent times is
> 68c90166e4aaa15ddcdd4778ad30bfb8b32534be, "Add support for using MII port
> with no PHY".

I have this terminal only one week, so it doesn't have to be recent regresion.
 
> Does applying the below backout patch fix things?

Unfortunatly no. But messages are a bit different sometimes.

VFS: Mounted root (ext2 filesystem).
Freeing unused kernel memory: 120k freed
eth0: DSPCFG accepted after 0 usec.
eth0: link up.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 40 usec.
[...]
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x200000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 40 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x200000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: increased tx threshold, txcfg 0xd0f01004.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 80 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: increased tx threshold, txcfg 0xd0f01004.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: increased tx threshold, txcfg 0xd0f01004.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 80 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: increased tx threshold, txcfg 0xd0f01004.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: increased tx threshold, txcfg 0xd0f01004.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: increased tx threshold, txcfg 0xd0f01004.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: increased tx threshold, txcfg 0xd0f01004.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Setting full-duplex based on negotiated link capability.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
eth0: increased tx threshold, txcfg 0xd0f01004.
eth0: DSPCFG accepted after 0 usec.
eth0: Wake-up event 0x80000a
eth0: Setting full-duplex based on negotiated link capability.
[...]

Please CC me.

Thank You
Rafał



----------------------------------------------------------------------
NIE KUPUJ!!!
...zanim nie porownasz cen >> http://link.interia.pl/f1a5e



