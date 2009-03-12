Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZCLACW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZCLACW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbZCLACJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:02:09 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:35196 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZCLACI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:02:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=DzQmHBSRj/u8MYL9lnCtHob3yOMgAnHBklQzEP1nHc+zPO8BjsqgS0XpnVjupPg6j5
         z/4Aw2OIhmudcCtHinuiQCWGh/ZxxWWkoafgltnEoha4bvEJoD5D5hJsDWZMn63ApRXM
         Sh15SJGrL16EPAGZEYRneb5Cbc1OajnBVElSk=
Message-ID: <49B850F7.90401@gmail.com>
Date: Wed, 11 Mar 2009 18:01:59 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: protagora27 protagora27 <protagora27@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: pci express bar over 4gb
References: <5b9cce670903110628p45248032u50dc253ed18b6e46@mail.gmail.com>
In-Reply-To: <5b9cce670903110628p45248032u50dc253ed18b6e46@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

protagora27 protagora27 wrote:
> Hello Folks,
> 
> I have intel desktop board dx48bt2. I'm developing sw under linux
> 2.6.24  x86_64  for a pci express card ( pci express 2.0 compliant).
> I have to setup pci bar over 4 gb but bios uses value e0000000 as base
> address for pcie boards.
> I have seen that pciexbar is a register ( x48 chipset)  that decides
> where pcie boards are mapped inside memory map.

No, the PCIEXBAR register controls where the MMCONFIG aperture is mapped 
in memory. (It's a rather unfortunate name, I think, as it doesn't 
really have anything to do with PCI Express other than that you need to 
use MMCONFIG to access PCI Express extended configuration space).

> My goal is rewriting pcibar 0 e pcibar 1 with a value above 4gb. Maybe
>  I have  to rewrite pciexbar and then rewrite pci bar in my board.
> Questions:
> 1) can I rewrite  pciexbar  and where ?
> 2) can i rewrite pcibar 0 and 1 with a value over 4 gb
> 3) If i change bar 0 and bar 1 after linux startup have i to use hotplugging ?
> 
> Thanks
> 
> Luca

