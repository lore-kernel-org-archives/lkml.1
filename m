Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbXFLUWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbXFLUWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 16:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbXFLUWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 16:22:43 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35685 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbXFLUWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 16:22:42 -0400
Message-ID: <466F008D.6060001@zytor.com>
Date: Tue, 12 Jun 2007 13:22:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
CC: Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: allocation failed: out of vmalloc space - use vmalloc=<size>
 to increase size.
References: <6278d2220706121001r38a1752axba90de1b4e315f75@mail.gmail.com>	 <466EE115.9030805@zytor.com> <1181676094.8164.26.camel@microwave.infinitevideocorporation.com>
In-Reply-To: <1181676094.8164.26.camel@microwave.infinitevideocorporation.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Dufresne wrote:
> I wasn't completely honest. It is one bar that has 512 MB, however it is
> being mapped at 4 128 MB chunks. However, I would like them all mapped
> at once through the lifetime of the driver.
> 
> Is there still no chance?

128 MB is still definitely on the heavy side.  Try 64 MB and you might
be able to get away with it.

	-hpa
