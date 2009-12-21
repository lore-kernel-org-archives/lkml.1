Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbZLUUnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbZLUUnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 15:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757151AbZLUUnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 15:43:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:47005 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086AbZLUUnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 15:43:06 -0500
Message-ID: <4B2FDD7D.1000906@kernel.org>
Date: Mon, 21 Dec 2009 12:41:33 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix size for ex trampoline with 32bit
References: <4B2F237F.3040909@kernel.org> <4B2FAD7B.7050701@zytor.com>
In-Reply-To: <4B2FAD7B.7050701@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 12/20/2009 11:27 PM, Yinghai Lu wrote:
>>
>> fix for error that is introduced by
>> | x86: Use find_e820() instead of hard coded trampoline address
>>
>> it should end with PAGE_SIZE + PAGE_SIZE
>>
> 
> 2*PAGE_SIZE?

should be the same. 

just try to restore to old one before i broke it.

YH
