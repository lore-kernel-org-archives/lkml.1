Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbXJDQdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbXJDQdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbXJDQde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 12:33:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57969 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbXJDQdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 12:33:33 -0400
Message-ID: <470514E7.4030809@zytor.com>
Date: Thu, 04 Oct 2007 09:29:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Arjan van de Ven <arjan@infradead.org>,
       kernel list <linux-kernel@vger.kernel.org>, jikos@jikos.cz
Subject: Re: video resume stuff
References: <20071004130513.GA16076@elf.ucw.cz> <20071004062848.0c55d182@laptopd505.fenrus.org> <20071004142437.GA4484@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20071004142437.GA4484@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> On Thu, 4 Oct 2007 15:05:13 +0200
>> Pavel Machek <pavel@ucw.cz> wrote:
>>
>>> Hi!
>>>
>>> I'm thinking about how to clean up video resume/how to get it to work
>>> for non-VESA video modes (jikos' case).
>>
>> I suspect in the medium run, the video mode setting stuff that's moving
>> into the kernel is the real answer to this problem... maybe it's more
>> efficient to move that in in a hurry ;)
> 
> Violently agreed... but we still want fallback for vesafb ;-).

It should also be pointed out that the first mode setting might very 
well be different from an already-in-operation modeset, if the procedure 
that we have access to doesn't initialize everything necessary.

	-hpa
