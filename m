Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbXGaKgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbXGaKgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbXGaKf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:35:56 -0400
Received: from mail.bmlv.gv.at ([193.171.152.37]:40909 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbXGaKfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:35:55 -0400
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: linux-kernel@vger.kernel.org
Subject: acpi=off vs. blacklist
Date: Tue, 31 Jul 2007 12:35:53 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311235.53302.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody!

I have two machines which freeze during boot; this seems to be ACPI-related, 
because with acpi=off they start.

The first one is the HP DC 7700; some summary can be seen on
  http://forums1.itrc.hp.com/service/forums/questionanswer.do?threadId=1081719
It hangs after a line
  ACPI assume root bridge[\sp_.pci0] bus is 0

The second one is a notebook; a Roda Rocky III+ RK886EX, which just shows a 
blank screen.

As we drive many machines from the same kernel image via PXE, I tried to 
insert them into drivers/acpi/blacklist.c; but that doesn't help, either - 
the notebook hangs as before, no matter whether I set is_critical_error or 
not. 
 [ I suppose I wrote the entries wrong; is there some HOWTO? I used
   acpidump/acpixtract/acpitbl, copied other blacklist entries, and took
   "OEM Table ID", "OEMID", "OEM REVISION". Help? ]


Using the "ACPI debug" kernel option showed no more messages.


Help, please? What can/should I do now?


Regards,

Phil
