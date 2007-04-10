Return-Path: <linux-kernel-owner+w=401wt.eu-S1031273AbXDJRgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031273AbXDJRgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031279AbXDJRgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:36:38 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35846 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031273AbXDJRgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:36:37 -0400
Message-ID: <461BCB1B.9060407@zytor.com>
Date: Tue, 10 Apr 2007 10:36:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Egmont Koblinger <egmont@uhulinux.hu>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
References: <20070406191245.GA11974@uhulinux.hu>	<4616A2C7.3030000@zytor.com>	<20070407092451.GA8779@uhulinux.hu>	<Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr>	<20070407172603.GA25351@uhulinux.hu>	<4617DBF7.5060009@zytor.com>	<20070410094325.GB9143@uhulinux.hu>	<461BB092.3070201@zytor.com>	<20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu>
In-Reply-To: <20070410183659.7341eeec@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> What do you exactly mean by this? Doing a binary search in a table of 11
>> intervals to find out whether a character is double-wide? Adding
>> approximately 30 lines of code (including the table and the binary search
>> routine) to the kernel to handle this case? I don't think it's bloat. It's a
> 
> I don't have a problem with it. It is a situation people find themselves
> in and framebuffer consoles can handle CJK although PC text mode ones
> can't do it well. It all comes down to a clean and small implementation.

All the CJK framebuffer consoles that handle CJK I've seen run in 
userspace on top of the kernel framebuffer.  Keeping a CJK font in the 
kernel seems prohibitive regardless of the hardware.

Have you seen anything different?

	-hpa
