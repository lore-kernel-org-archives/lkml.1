Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbZFMF5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbZFMF5I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 01:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZFMF4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 01:56:54 -0400
Received: from mail-yx0-f200.google.com ([209.85.210.200]:52576 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbZFMF4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 01:56:54 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Jun 2009 01:56:53 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Lp9y07dPsBrftbhQAxLoNgRjB/eH8feWWwNj3pZV6fizNQ+9WEBfLSxVEay+pFkYqn
         HbgssLZsnebrwJCvkOZAaJtOdHFbaOkRKAdfHmJ8g2cmxQ490ZMIBBIV5gI1baprwfpy
         YYXLO/d7sqBuCHFuqS9AIWEILAzth9wbPPKIA=
Message-ID: <4A333E0D.8050306@gmail.com>
Date: Fri, 12 Jun 2009 23:50:05 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Sanka Piyaratna <cesanka@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PCIe interface memory memory mapping issue
References: <233030.36441.qm@web31706.mail.mud.yahoo.com>
In-Reply-To: <233030.36441.qm@web31706.mail.mud.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2009 06:23 AM, Sanka Piyaratna wrote:
> Hi,
>
> I have developed a PCI express interface using Xilinx ML555 hardware module. I have implemented Linux kernel mode device drivers and everything works correctly as long as I am using the device within a computer with dual channel DDR arrangement. However, as soon as I pug this device into a core i7 or an older single channel DDR machine, the interface memory mapping does not work any more. As if the register map with in the device does no longer exsists. However, "lspci" utility provides correct information. I am not sure if this has anything to do with the number of DDR memory channels the motherboard has or why that would be a problem for PCI express device. However, this seem to be the common link between the machines that demonstrate this issue.

You'll have to give more details on what you mean by "the interface 
memory mapping does not work any more. As if the register map with in 
the device does no longer exsists".
