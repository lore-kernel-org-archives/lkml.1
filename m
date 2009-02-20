Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbZBTA0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbZBTA0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 19:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbZBTA0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 19:26:14 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:8345 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZBTA0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 19:26:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=AXwEKRKBV+7XvLlZL52J8LagS52MEPM7ER0PBffororZ1Jq/VshP+2HQBk7F2a3Msy
         cWQjoha276rDDfdFcn9ickRPlOZp6oKqm6TchQXz5Fjs9MGsYRhA9fJ+Yp6O+OOZlmrQ
         sizt/3i+dZO11pb26jm/L2UdEg8YejUahoSdY=
Message-ID: <499DF89F.5030504@gmail.com>
Date: Thu, 19 Feb 2009 18:26:07 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: joseluismarchetti@yahoo.com.br
CC: linux-kernel@vger.kernel.org
Subject: Re: Is interrupt priority supported ?
References: <657201.46675.qm@web34402.mail.mud.yahoo.com>
In-Reply-To: <657201.46675.qm@web34402.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jose Luis Marchetti wrote:
> Hi,
> 
> I am experiencing serial (115K) data loss when I have concurrent heavy Ethernet traffic. I have added some basic trace into the UART driver and could confirm the Ethernet data interrupt, if with enough data and happening in the right place would cause the UART FIFO to fill.
> BTW this is happening on a embedded processor, not on the usual ( and fast ) PC.
> Then I tried to set the serial interrupt priority to be higher than the Ethernet interrupt priority, just because the UART I am using have just 4 bytes of FIFO while the Ethernet have thousands...
> 
> But I am not able to find where this is done in Linux, is interrupt priority supported at all ?
> 
> Thanks in advance for any comments,

You didn't say what platform this was, it likely matters a fair bit.

I don't know that changing interrupt priority is necessarily likely to 
do much, though. If the network card driver is disabling interrupts 
while handling packets and that's what's causing the problem, then it 
won't help.
