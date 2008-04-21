Return-Path: <linux-kernel-owner+w=401wt.eu-S1759861AbYDUPPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861AbYDUPPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbYDUPPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:15:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbYDUPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:15:08 -0400
Message-ID: <480CADD3.3010209@zytor.com>
Date: Mon, 21 Apr 2008 11:08:03 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Pavel Machek <pavel@ucw.cz>, mingo@elte.hu, akpm@osdl.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
References: <20080417165839.GA25198@Krystal> <20080417165944.GB25198@Krystal> <20080417201410.GB31616@Krystal> <20080421140054.GB4685@ucw.cz> <480CA337.3090709@zytor.com> <20080421150825.GA4070@Krystal>
In-Reply-To: <20080421150825.GA4070@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> Just to be clear : the added cost on normal interrupt return is to add a
> supplementary test of the thread flags already loaded in registers and
> a conditional branch. This is used to detect if we are nested over an
> NMI handler. I doubt anyone ever notice an impact caused by this added
> test/branch.
> 

Why the **** would you do this except in the handful of places where you 
actually *could* be nested over an NMI handler (basically #MC, #DB and 
INT3)?

	-hpa

