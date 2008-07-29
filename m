Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbYG2Ju7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbYG2Ju7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbYG2JuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:50:22 -0400
Received: from mail.renesas.com ([202.234.163.13]:63725 "EHLO
	mail05.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756839AbYG2JuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:50:20 -0400
X-AuditID: ac140388-0000000700006b18-10-488ee7d930ac
Message-ID: <488EE7BF.4020908@rsel.renesas.com>
Date: Tue, 29 Jul 2008 11:49:51 +0200
From: "Oliver Soltys" <oliver.soltys@rsel.renesas.com>
Reply-To: Oliver.Soltys@rsel.renesas.com
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: de-DE, de, en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: directory sort order no longer beginning with "." and ".."?
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

we experienced some change in the directory sort order. We installed a new
server with kernel 2.6.18. While testing, an old (but important) application
won't correctly show a directory selection window (is there a name for such a
thing?) when changing to a NFS (version2) mounted directory.

Further investigations showed, that up to kernel 2.6.11 a "ls -f" gave a
unsorted directory listing, but beginning with "." and "..".

Newer kernel (I checked 2.6.18 and 2.6.25) have the "." and ".." somewhere else
in the "ls -f" output.

The same sort order can be seen using nfsV2 with "tcpdump".

I think this the reason for our application to behave weird.

My question: is this a bug, or a feature? I could not find anything about that
anywhere...

Does anybody have an idea, how I can fix this? Unfortunately, our application
can not be changed.

Many thanks in advance & best regards,
Oliver Soltys

****************************************************************************
This email and any files transmitted with it are confidential and
intended solely for the use of the individual or entity to whom they
are addressed. Access to this e-mail by anyone else is unauthorised.
If you are not the intended recipient, any disclosure, copying,
distribution or any action taken or omitted to be taken in reliance on
it, is prohibited.
E-mail messages are not necessarily secure.  Renesas does not accept
responsibility for any changes made to this message after it was sent.
Please note that this email message has been swept by Renesas for
the presence of computer viruses.

Renesas Semiconductor Europe (Landshut) GmbH
Jenaer Strasse 1, 84034 Landshut
Tel.: +49-(0)871-684-0, Fax: +49-(0)871-684-150
www.rsel.renesas.com

GESCHAEFTSFUEHRER:  Dipl.-Ing. YOSHIHARU KAKUI
GESCHAEFTSFUEHRER:  Dipl.-Phys. STEFAN SAUER

Registergericht Landshut HRB 1464
Ust-ldNr.: DE 128953054  Steuer-Nr.: 132/136/30347

HypoVereinsbank, Landshut, Kto.-Nr. 3704 700 (BLZ  743 200 73) 
Mizuho Corporate Bank (Germany) AG, Frankfurt, Kto.-Nr. 200 733 (BLZ 503 308 00)
****************************************************************************

