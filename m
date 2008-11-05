Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYKEAmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYKEAmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 19:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbYKEAmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 19:42:33 -0500
Received: from gw.goop.org ([64.81.55.164]:37350 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbYKEAmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 19:42:33 -0500
Message-ID: <4910EBF5.7070506@goop.org>
Date: Tue, 04 Nov 2008 16:42:29 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Alexander van Heukelum <heukelum@fastmail.fm>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <20081104210643.GH29626@one.firstfloor.org>
In-Reply-To: <20081104210643.GH29626@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> ???  LOCK slowness is not because of the bus. And I know you know 
> that Ingo, so I don't know why you wrote that bogosity above.
>   

Why are the accesses locked?  Is it because it does an update of the 
accessed bit in the descriptor?  (We should be pre-setting them all anyway.)

    J
