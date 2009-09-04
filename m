Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZIDNK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZIDNK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 09:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbZIDNKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 09:10:25 -0400
Received: from mail-yw0-f192.google.com ([209.85.211.192]:56999 "EHLO
	mail-yw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbZIDNKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 09:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=LVVN+hJ0OPvERAYCB2nKpcjKpEU40AzL1oYQcWMzi+yyMJd0Qrhov5ia+LArQ5Vp6x
         AgCo6DVEFNjsQxw+MgSJV9KP0f0dPXgBMGDDGDRKEZ96m8OdZdKqnqNUQy+l3yx/OrLG
         qE/zYKwt+V0Nha+Fjib9za3iBMDkiDcODnh0A=
MIME-Version: 1.0
Date: Fri, 4 Sep 2009 10:04:22 -0300
Message-ID: <d970ff420909040604h1bb3874eg5c79f79f85e713a3@mail.gmail.com>
Subject: MPC85xx External/Internal Interrupts
From: Alemao <xcarandiru@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In all MPC85xx DTS files I have seen this interrupt configuration for
TSEC1:

interrupts = <29 2 30 2 34 2>;

29 - TSEC1 interrupt transmit
30 - TSEC1 interrupt receive
34 - TSEC1 interrupt error


But in MPC8555RM, chapter 10.1.5.2 the numbers are these:

13 - TSEC1 interrupt transmit
14 - TSEC1 interrupt receive
18 - TSEC1 interrupt error


Im a little bit confused about this internal interrupts, how can I get
this numbers? TSEC1 is working normally.


My real problem is that my driver is trying to request the external
interrupt IRQ0, and I dont know what number use in INTR_NUM:

request_irq(INTR_NUM, , , , )


Im using linux-2.6.26

Cheers,

--
Alemao
