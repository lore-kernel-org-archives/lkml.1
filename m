Return-Path: <linux-kernel-owner+w=401wt.eu-S937256AbXLQUPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937256AbXLQUPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760608AbXLQT4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:56:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57433 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762367AbXLQT42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:56:28 -0500
Message-ID: <4766D417.7040403@zytor.com>
Date: Mon, 17 Dec 2007 11:55:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Ingo Molnar <mingo@elte.hu>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <20071217105744.GA14315@elte.hu> <4766684D.40202@gmail.com> <20071217130933.GB27992@elte.hu> <47667812.8050708@gmail.com> <47667A85.3080100@reed.com> <20071217143900.GA16604@elte.hu> <4766D035.7090104@reed.com>
In-Reply-To: <4766D035.7090104@reed.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> 
> Still wondering:
> 
>    what the heck is going on with port 80 on my laptop motherboard.  
> Clearly it "does something".
>    I will in my spare time continue investigating, though having a 
> reliable system is GREAT.
> 

Almost guaranteed to be some kind of debugging hack, probably 
implemented either in the SuperIO chip or in SMM (or both).  When some 
sort of log buffer fills up, the system dies.

	-hpa
