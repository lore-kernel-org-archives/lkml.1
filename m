Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbXKLVY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbXKLVY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 16:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbXKLVYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 16:24:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55127 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbXKLVYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 16:24:17 -0500
Message-ID: <4738C3AE.1070104@zytor.com>
Date: Mon, 12 Nov 2007 13:20:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Max Asbock <masbock@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, tglx@linutronix.de, mingo@redhat.com
Subject: Re: x86 32-bit machine check handler
References: <1194899975.9979.7.camel@w-amax.beaverton.ibm.com>
In-Reply-To: <1194899975.9979.7.camel@w-amax.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Max Asbock wrote:
> Now that the 32-bit and 64-bit x86 machine check handlers live next to
> each other a certain asymmetry in functionality is apparent. Notably,
> the 64-bit machine check handler implements a timer that periodically
> polls for silent machine check errors and makes them accessible to user
> space through /dev/mcelog. Are there reasons the x86 32-bit machine
> check handler couldn't do the same?

No, and in fact, it should.

	-hpa
