Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYLOO2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYLOO2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbYLOO1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:27:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49886 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbYLOO1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:27:54 -0500
Message-ID: <4946695A.9080603@zytor.com>
Date: Mon, 15 Dec 2008 06:27:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Philipp Kohlbecher <xt28@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: documentation fix regarding boot protocol
References: <49454749.2030901@gmx.de> <1229332954.25349.78.camel@zakaz.uk.xensource.com>
In-Reply-To: <1229332954.25349.78.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> 
> The padding after the real-mode code which you mention is just the
> implicit padding because the size of the real-mode code is specified in
> sectors (and hence is rounded up), isn't it?
> 
> Is it worth saying that the payload_offset is relative to (setup_sectors
> +1) * 512?
> 

Yes, the padding is considered part of the real mode code.  The phrasing 
you're suggesting is probably the most unambiguous, though.

	-hpa

