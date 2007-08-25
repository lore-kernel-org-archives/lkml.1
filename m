Return-Path: <linux-kernel-owner+w=401wt.eu-S1761821AbXHYCnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761821AbXHYCnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 22:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXHYCnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 22:43:09 -0400
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:39298 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911AbXHYCnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 22:43:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=powAlk4XjLOJMCAN5booom34NH4/BuZvXnywH4YzRWSJ1p3dar2nk5aTogVDwBW/;
  h=Received:Message-ID:Reply-To:From:To:Cc:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <000501c7e6bd$2576d260$6501a8c0@earthlink.net>
Reply-To: "Mitchell Erblich" <erblichs@earthlink.net>
From: "Mitchell Erblich" <erblichs@earthlink.net>
To: "Jan-Bernd Themann" <ossthema@de.ibm.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: issues concerning the next NAPI interface
Date: Fri, 24 Aug 2007 19:10:43 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1106
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79586d9e7b3ffe099efb59f7cb53d22509350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.165.174.119
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann,

                  IMO, a box must be aware of the speed of all its
interfaces, whether the
                  interface impliments tail-drop or RED or XYZ, the latency
to access the
                  packet, etc.

                  Then when a packet arrives, a timer is started for
interrupt colelesing,
                  and to process awaiting packets, if tail-drop is
implemented, it is
                  possible to wait until a the input FIFO fills to a
specific point before
                  starting a timer.

                  This may maximize the number of packets per interupt. And
realize that
                  the worse case of a interrupt per packet is wirespeed
pings (echo
                  request/reply) of 64 bytes per packet.

                   Mitchell Erblich




