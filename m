Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbXGSMmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbXGSMmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbXGSMmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:42:06 -0400
Received: from maxwell.spina.si ([193.77.104.223]:50069 "EHLO maxwell.spina.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599AbXGSMmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:42:04 -0400
Message-ID: <469F5C1A.6010003@kanardia.eu>
Date: Thu, 19 Jul 2007 14:42:02 +0200
From: Rok Markovic <kernel@kanardia.eu>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Mike Rapoport <mike@compulab.co.il>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Oops on arm pxa270 2.6.22
References: <469F1CDA.8080304@kanardia.eu> <469F4525.5040309@compulab.co.il>
In-Reply-To: <469F4525.5040309@compulab.co.il>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Rapoport wrote:

> I think you have conflict between PXA serial and 8250 drivers. Make sure 
> you use only one of them.
> If you need to use PCMCIA serial cards, please see 
> http://lists.arm.linux.org.uk/pipermail/linux-arm-kernel/2007-July/040604.html 
> 


Thanks, I already fixed my problem. You are right it was serial port
problem. I had wrong MAJOR and MINOR numbers in serial/pxa.c Now kerel boots 
and works fine with -ck patch.

My I ask you if you (compulab) have any plans of merging machine cm-x270 patches
into mainline kernel.

Thanks again,
Rok Markovic
 

