Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbYIUOQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbYIUOQm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 10:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbYIUOQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 10:16:32 -0400
Received: from web52903.mail.re2.yahoo.com ([206.190.49.13]:47373 "HELO
	web52903.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751592AbYIUOQc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 10:16:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=xnWJjsQBZpXbufIBVC1gelgiW9n39UuslKNSYypphJrpUb4YTipyyXPNch8/moczbZUwlX0Id79MuMI0SJ8lZFG2FuocdPO4Dr6gLgDUveK/nXxvbBfUjQwV+rbihz8vPFpjfKuni43BCg0kzPvg+nwPaINPafSFD7xnx7EcaWY=;
X-YMail-OSG: uQA21JgVM1nDAftAG3JDSlv6OBnB7lBGhMMzpypW0z15_cxHmgneOVnk3tysJK.vfrn9wRnJfPRkYlGGDLkdLj8pF_vTNJdpz3vFXhutEgkHuMCpE709K0jcNEef0eYn3q5vclUkakVaBtkt4Inp.VncovIY5MLq0pWbyKrzWlgb9ngI2p0-
X-Mailer: YahooMailWebService/0.7.218.2
Date: Sun, 21 Sep 2008 07:16:30 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: rankincj@yahoo.com
Subject: Re: Thinkpad T60p does not recover from Suspend when docked.
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <888845.45804.qm@web52903.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have now migrated my laptop to the 2.6.26.5 kernel, and it is still failing to resume from "suspend to RAM" if the SATA drive is in the docking bay. I did notice the following in the dmesg log, which might be relevant:

ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
ACPI: Error installing bay notify handler

I have raised this as bug #11604 at bugzilla.kernel.org.

Cheers,
Chris


      
