Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbXBDVRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbXBDVRL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 16:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbXBDVRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 16:17:11 -0500
Received: from nz-out-0506.google.com ([64.233.162.236]:24042 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbXBDVRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 16:17:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q/CZCAXNKdN2f+g/rmdYs0ZNrjRXMiUPIEZSMYw4+wEuypOAXbfBzZT9ech9qADLXt7e8iFlEKuwIpMQrSOs0ua8SEf3ikvIAG3WKYuoU+1rD2+9FBssOVEWIAi7UxqQ4+fjQUkG+3+dK+RF2LSERwAVViRshyWHIv6QtHvya0Q=
Message-ID: <cb7bb73a0702041317u4ca2fbabp45cf56526e57c982@mail.gmail.com>
Date: Sun, 4 Feb 2007 22:17:08 +0100
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Luca Tettamanti" <kronos@people.it>
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Cc: linux-fbdev-devel@lists.sourceforge.net, "Andrew Morton" <akpm@osdl.org>,
       "Dave Airlie" <airlied@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070204201713.GA12867@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ephv35$4i3$1@sea.gmane.org>
	 <20070128160831.fb51347f.akpm@osdl.org>
	 <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com>
	 <20070128162907.370f5476.akpm@osdl.org>
	 <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com>
	 <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com>
	 <20070130203301.GA15067@dreamland.darkstar.lan>
	 <20070204201713.GA12867@dreamland.darkstar.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/07, Luca Tettamanti <kronos@people.it> wrote:
> Giuseppe, can you send me the EDID block of your monitor?

I'd gladly do it, if I knew how to retrieve it ... because apparently,
get-edid doesn't work, even though both the nv driver for X and
nvidiafb manage to retrieve it.

This is the output from get-edid

"""
get-edid: get-edid version 1.4.1

	Performing real mode VBE call
	Interrupt 0x10 ax=0x4f00 bx=0x0 cx=0x0
	Function supported
	Call successful

	VBE version 300
	VBE string at 0x11110 "NVidia"

VBE/DDC service about to be called
	Report DDC capabilities

	Performing real mode VBE call
	Interrupt 0x10 ax=0x4f15 bx=0x0 cx=0x0
	Function supported
	Call successful

	Monitor and video card combination does not support DDC1 transfers
	Monitor and video card combination does not support DDC2 transfers
	0 seconds per 128 byte EDID block transfer
	Screen is not blanked during DDC transfer

Reading next EDID block

VBE/DDC service about to be called
	Read EDID

	Performing real mode VBE call
	Interrupt 0x10 ax=0x4f15 bx=0x1 cx=0x0
	Function supported
	Call failed

The EDID data should not be trusted as the VBE call failed
Error: output block unchanged
"""

Anything else I can try?

-- 
Giuseppe "Oblomov" Bilotta
