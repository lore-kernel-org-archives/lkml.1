Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYDFQnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYDFQnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 12:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbYDFQnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 12:43:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51555 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbYDFQnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 12:43:09 -0400
Message-ID: <47F8FC9C.9090603@zytor.com>
Date: Sun, 06 Apr 2008 09:38:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ian Campbell <ijc@hellion.org.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCHv3 1/3] x86: use ELF format in compressed images.
References: <1202936100-30859-1-git-send-email-ijc@hellion.org.uk>	 <9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk> <86802c440804060003q43f14122vd527514daf77cb89@mail.gmail.com>
In-Reply-To: <86802c440804060003q43f14122vd527514daf77cb89@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> so will cost every bzImage extra memory copy? that could be 18M or
> even more big.

I wouldn't worry about that.  You will typically have several copies of 
the images during the execution of the boot loader.

	-hpa
