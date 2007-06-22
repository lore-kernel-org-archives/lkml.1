Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbXFVVgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbXFVVgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbXFVVgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:36:46 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39259 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbXFVVgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:36:44 -0400
Date: Fri, 22 Jun 2007 14:38:09 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
In-reply-to: <200706222328.21259.ak@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <467C4141.9010507@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=iso-8859-1
Content-transfer-encoding: 7BIT
References: <200706221219.16243.yinghai.lu@sun.com>
 <20070622193124.GG5051@rhun.smartcity.com>
 <20070622213327.69663288@the-village.bc.nu> <200706222328.21259.ak@suse.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> It's probably too late then. It could also interfere with other operations.
> If anything the GART should be disabled during kexec shutdown. Perhaps we just 
> need a suitable suspend function that does that. Eric, any preferences? 

how about kdump? do we have chance to call that suspend func?

YH
