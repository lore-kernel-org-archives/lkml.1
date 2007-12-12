Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbXLLX5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbXLLX5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 18:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbXLLX5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 18:57:30 -0500
Received: from mail44.messagelabs.com ([216.82.249.179]:10593 "HELO
	mail44.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751006AbXLLX5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 18:57:30 -0500
X-VirusChecked: Checked
X-Env-Sender: arasv@magtech.com.au
X-Msg-Ref: server-3.tower-44.messagelabs.com!1197503849!504454!1
X-StarScan-Version: 5.5.12.14.2; banners=magtech.com.au,-,-
X-Originating-IP: [150.101.126.166]
Message-ID: <47607564.2040900@magtech.com.au>
Date: Thu, 13 Dec 2007 10:57:24 +1100
From: Aras Vaichas <arasv@magtech.com.au>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: mmaping an IO port device
References: <4760727E.2090906@magtech.com.au>
In-Reply-To: <4760727E.2090906@magtech.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aras Vaichas wrote:
> I then call ioread16(FPGA_base + FPGA_register) for both x86 and ARM 
> and it all works perfectly. No problems there.
Oop, sorry I lied a little. I actually use inw/outw for the x86 version.

e.g. inw( FPGA_REG_IO_BASE + FPGA_register);

but the main problem still stands ...

Aras


______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email 
______________________________________________________________________
