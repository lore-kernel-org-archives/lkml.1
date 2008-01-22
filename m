Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbYAVU2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbYAVU2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYAVU1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:27:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46938 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbYAVU1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:27:50 -0500
Message-ID: <4796519C.6040501@zytor.com>
Date: Tue, 22 Jan 2008 12:27:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>, mingo@redhat.com,
       tglx@linutronix.de
Subject: Re: factor out common s2ram wakeup code
References: <20080122193719.GA3791@elf.ucw.cz>
In-Reply-To: <20080122193719.GA3791@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> It seems to compile 32/64bit, and work 32bit... Now, video code should
> be probably shared with kernel/boot; but that was rewritten to C and
> I'm not sure if I know enough about linkers... basically the C code
> should replace mode_set() and friends. Peter, can you help?

Yes, absolutely.  I think we should probably segregate out into a 
subdirectory the part of the code that should be run in 16-bit mode, and 
then it's just a matter of pretty much replicating the mechanisms used 
in arch/x86/boot.

How can I best be of help?

	-hpa
