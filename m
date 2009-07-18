Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbZGRSHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbZGRSHB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 14:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZGRSHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 14:07:00 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:52805 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbZGRSG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 14:06:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Tx+AjEFv5KVL0epqa2aJUpw7G+T+pKtKnegSRsU9CNHl/5zZM3KE+evaQiZTSblKQ0
         hGw8FJyQL9+PoItpxvgrVG7c5wQ95hmNazE/A0cgKJ2RZR8GrEMiXFL7SSWZS6N945D8
         lqVYjCU+i3WgxqYa+jw7OBvqOqHdQP3pmF2dc=
Message-ID: <4A620F3E.8080900@tuffmail.co.uk>
Date: Sat, 18 Jul 2009 19:06:54 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: "floppy: fix hibernation" causes error on resume from ram
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the hibernation fix!  Until recently I thought my floppy was
just dead.  Unfortunately, the fix seems to cause me errors on resume
from suspend to ram.  The floppy works fine afterwards, it just spams
the log.

On 2.6.30 there were no errors, and the floppy survived suspend-to-ram. 
So I guess the quick fix would be to only do the fix-up on resume from
hibernation, and not suspend-to-ram.

Thanks
Alan

Jul 18 15:27:23 alan-desktop kernel: [34795.256645]
Jul 18 15:27:23 alan-desktop kernel: [34795.256647] floppy driver state
Jul 18 15:27:23 alan-desktop kernel: [34795.256649] -------------------
Jul 18 15:27:23 alan-desktop kernel: [34795.256652] now=4305315874 last
interrupt=4303125175 diff=2190699 last called handler=ffffffffa00a64d0
Jul 18 15:27:23 alan-desktop kernel: [34795.256655] timeout_message=lock fdc
Jul 18 15:27:23 alan-desktop kernel: [34795.256657] last output bytes:
Jul 18 15:27:23 alan-desktop kernel: [34795.256659]  8 80 4295201276
Jul 18 15:27:23 alan-desktop kernel: [34795.256662]  8 80 4295201276
Jul 18 15:27:23 alan-desktop kernel: [34795.256664]  8 80 4295201276
Jul 18 15:27:23 alan-desktop kernel: [34795.256666]  8 80 4295201276
Jul 18 15:27:23 alan-desktop kernel: [34795.256668]  8 80 4297332499
Jul 18 15:27:23 alan-desktop kernel: [34795.256669]  8 80 4297332499
Jul 18 15:27:23 alan-desktop kernel: [34795.256671]  8 80 4297332499
Jul 18 15:27:23 alan-desktop kernel: [34795.256673]  8 80 4297332499
Jul 18 15:27:23 alan-desktop kernel: [34795.256675]  8 80 4298652310
Jul 18 15:27:23 alan-desktop kernel: [34795.256677]  8 80 4298652310
Jul 18 15:27:23 alan-desktop kernel: [34795.256679]  8 80 4298652310
Jul 18 15:27:23 alan-desktop kernel: [34795.256681]  8 80 4298652310
Jul 18 15:27:23 alan-desktop kernel: [34795.256683]  8 80 4299614961
Jul 18 15:27:23 alan-desktop kernel: [34795.256685]  8 80 4299614961
Jul 18 15:27:23 alan-desktop kernel: [34795.256687]  8 80 4299614961
Jul 18 15:27:23 alan-desktop kernel: [34795.256689]  8 80 4299614961
Jul 18 15:27:23 alan-desktop kernel: [34795.256691]  8 80 4303125175
Jul 18 15:27:23 alan-desktop kernel: [34795.256693]  8 80 4303125175
Jul 18 15:27:23 alan-desktop kernel: [34795.256695]  8 80 4303125175
Jul 18 15:27:23 alan-desktop kernel: [34795.256697]  8 80 4303125175
Jul 18 15:27:23 alan-desktop kernel: [34795.256699] last result at
4303125175
Jul 18 15:27:23 alan-desktop kernel: [34795.256701] last redo_fd_request
at 4303125175
Jul 18 15:27:23 alan-desktop kernel: [34795.256703]
Jul 18 15:27:23 alan-desktop kernel: [34795.256709] status=0
Jul 18 15:27:23 alan-desktop kernel: [34795.256711] fdc_busy=1
Jul 18 15:27:23 alan-desktop kernel: [34795.256713]
do_floppy=ffffffffa00a64d0
Jul 18 15:27:23 alan-desktop kernel: [34795.256715] cont=ffffffffa00ad8c0
Jul 18 15:27:23 alan-desktop kernel: [34795.256717] current_req=(null)
Jul 18 15:27:23 alan-desktop kernel: [34795.256719] command_status=-1
Jul 18 15:27:23 alan-desktop kernel: [34795.256720]
Jul 18 15:27:23 alan-desktop kernel: [34795.256829] floppy0: floppy
timeout called
Jul 18 15:27:23 alan-desktop kernel: [34795.259455] Restarting tasks ...
done.

