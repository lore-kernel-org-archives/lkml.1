Return-Path: <linux-kernel-owner+w=401wt.eu-S1765587AbXLNLLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765587AbXLNLLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 06:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758351AbXLNLLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 06:11:39 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:63506 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831AbXLNLLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 06:11:38 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 63.115.24.214
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Zt0f/Tx9XH1El+sQWYvXB
Message-ID: <476264E5.3090809@reed.com>
Date: Fri, 14 Dec 2007 06:11:33 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>	<469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <p73prx9ft1v.fsf@bingen.suse.de>
In-Reply-To: <p73prx9ft1v.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andi Kleen wrote:
> "
> With the additional call this should be completely out of line now to save 
> code size. Similar for the in variant.
>
>
>   
Sure.  Want me to make a new patch with the _p croutines out-of-line?
