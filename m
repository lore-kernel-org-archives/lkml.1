Return-Path: <linux-kernel-owner+w=401wt.eu-S932717AbYFGAKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbYFGAKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 20:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758500AbYFGAKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 20:10:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41366 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413AbYFGAKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 20:10:22 -0400
Message-ID: <4849D059.1000701@zytor.com>
Date: Fri, 06 Jun 2008 17:03:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: Recoverable MCA interrupts from NMI handlers?  IPMI and RCU?
References: <20080606152134.GA13641@linux.vnet.ibm.com> <4849A3AC.5090107@acm.org>
In-Reply-To: <4849A3AC.5090107@acm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Minyard wrote:
> If you mean the IPMI driver, it does not tie into any SMI.  It 
> theoretically could since there's a bit for that in the watchdog timer, 
> but there's been no demand and I haven't looked at it.  I guess it would 
> be better than an NMI.
> 
> If it did tie in, it would most likely just panic to get useful 
> information out before the watchdog reset the system.

The main reason I could see wanting to use SMI would be as a debugging 
tool, since SMI makes the entire state of the system available at a low 
level; however, trying to interact with the state of the kernel at this 
priority level seems beyond the pale in terms of complexity.

	-hpa
