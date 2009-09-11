Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbZIKWVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbZIKWVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbZIKWVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:21:44 -0400
Received: from claw.goop.org ([74.207.240.146]:53349 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbZIKWVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:21:43 -0400
Message-ID: <4AAACD79.5020105@goop.org>
Date: Fri, 11 Sep 2009 15:21:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/xen for v2.6.32
References: <20090911200135.GA1426@elte.hu> <alpine.LNX.2.00.0909120000010.31018@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.0909120000010.31018@swampdragon.chaosbits.net>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/09 15:07, Jesper Juhl wrote:
> Why is this cast of 'va' needed?  As far as I can see, 'va' already has 
> the correct type of "unsigned long".
> Pointless casts do more harm than good, let's remove this one :-)
>   

Yup.  Don't know what lead me to put it there; cut'n'paste, possibly. 
Anyway, I'll send out a fix when I get around to it.

    J
