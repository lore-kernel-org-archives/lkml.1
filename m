Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbYBTJsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbYBTJsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 04:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbYBTJsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 04:48:35 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:44192 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbYBTJse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 04:48:34 -0500
Message-ID: <47BBF771.40203@s5r6.in-berlin.de>
Date: Wed, 20 Feb 2008 10:48:33 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.25-rc2: ohci1394 problem
References: <47BBDB07.80409@m3y3r.de>
In-Reply-To: <47BBDB07.80409@m3y3r.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote at LKML:
> Hi.
> 
> With 2.6.25-rc2 my kernel log consists mainly of:
> 
> "ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
> ohci1394: fw-host0: Unrecoverable error!
> ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] 
> cmdptr[f0002a00]
> ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] 
> cmdptr[0005c806] match[00000000]
> ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] 
> cmdptr[f58b18cd] match[4910c683]
> ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] 
> cmdptr[88f2eb10] match[46e8104e]
> ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] 
> cmdptr[83060246] match[83060846]
> ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] 
> cmdptr[6e696461] match[706f2067]
> ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] 
> cmdptr[61726570] match[676e6974]
> ohci1394: fw-host0: physical posted write error
> ohci1394: fw-host0: respTxComplete: dma prg stopped
> ohci1394: fw-host0: SelfID received outside of bus reset sequence
> ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
> ohci1394: fw-host0: Unrecoverable error!
> ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] 
> cmdptr[f0002a00]
> ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] 
> cmdptr[0005c806] match[00000000]
> ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] 
> cmdptr[f58b18cd] match[4910c683]
> ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] 
> cmdptr[88f2eb10] match[46e8104e]
> ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] 
> cmdptr[83060246] match[83060846]
> ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] 
> cmdptr[6e696461] match[706f2067]
> ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] 
> cmdptr[61726570] match[676e6974]
> ohci1394: fw-host0: physical posted write error
> ohci1394: fw-host0: respTxComplete: dma prg stopped
> ohci1394: fw-host0: SelfID received outside of bus reset sequence
> ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
> ohci1394: fw-host0: Unrecoverable error!
> "
> 
> Strange, isn't it?

Do you have any hardware attached to the FireWire bus at that time?

What does /proc/interrupts contain?
-- 
Stefan Richter
-=====-==--- --=- =-=--
http://arcgraph.de/sr/
