Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZAJIZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZAJIZc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 03:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZAJIZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 03:25:24 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:10423 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbZAJIZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 03:25:23 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=OwZ1pnPJ2TEwFTJaqVcA:9 a=8SrV7XpFjtWvoaBtkzF1FDF6zdAA:4 a=M-ExZQ-wgAMA:10 a=dXD_W6XKJooA:10
Message-ID: <49685B70.8080908@shaw.ca>
Date: Sat, 10 Jan 2009 02:25:20 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN
 (4)
References: <49683957.9070700@gmail.com>
In-Reply-To: <49683957.9070700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> I am seeing this in dmesg:
> FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
> not sure what this is.
> (the only changes to .config was add kexec,
> coredump, and relocatable kernel options.)
> 
> I take it that I'm unable to try this relocatable
> kernel stuff out.(x86_32)?
> 
> regards;
> 
> Justin P. Mattock

I believe that indicates your BIOS's FADT table contains inconsistent 
data. You're sure that only happens with those options set?
