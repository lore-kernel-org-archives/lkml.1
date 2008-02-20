Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbYBTHrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbYBTHrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 02:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYBTHr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 02:47:28 -0500
Received: from www17.your-server.de ([213.133.104.17]:45470 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832AbYBTHr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 02:47:27 -0500
Message-ID: <47BBDB07.80409@m3y3r.de>
Date: Wed, 20 Feb 2008 08:47:19 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20080211)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.25-rc2: ohci1394 problem
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

With 2.6.25-rc2 my kernel log consists mainly of:

"ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
ohci1394: fw-host0: Unrecoverable error!
ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] 
cmdptr[f0002a00]
ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] 
cmdptr[0005c806] match[00000000]
ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] 
cmdptr[f58b18cd] match[4910c683]
ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] 
cmdptr[88f2eb10] match[46e8104e]
ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] 
cmdptr[83060246] match[83060846]
ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] 
cmdptr[6e696461] match[706f2067]
ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] 
cmdptr[61726570] match[676e6974]
ohci1394: fw-host0: physical posted write error
ohci1394: fw-host0: respTxComplete: dma prg stopped
ohci1394: fw-host0: SelfID received outside of bus reset sequence
ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
ohci1394: fw-host0: Unrecoverable error!
ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] 
cmdptr[f0002a00]
ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] 
cmdptr[0005c806] match[00000000]
ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] 
cmdptr[f58b18cd] match[4910c683]
ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] 
cmdptr[88f2eb10] match[46e8104e]
ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] 
cmdptr[83060246] match[83060846]
ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] 
cmdptr[6e696461] match[706f2067]
ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] 
cmdptr[61726570] match[676e6974]
ohci1394: fw-host0: physical posted write error
ohci1394: fw-host0: respTxComplete: dma prg stopped
ohci1394: fw-host0: SelfID received outside of bus reset sequence
ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
ohci1394: fw-host0: Unrecoverable error!
"

Strange, isn't it?

regards
thomas

