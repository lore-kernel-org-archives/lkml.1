Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYAYFxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYAYFxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYAYFxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:53:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53166 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYAYFxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:53:24 -0500
Message-ID: <47997735.1020501@zytor.com>
Date: Thu, 24 Jan 2008 21:44:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v2
References: <47993F1A.5070408@goop.org> <4799400C.1060102@zytor.com> <200801241947.55223.yinghai.lu@sun.com>
In-Reply-To: <200801241947.55223.yinghai.lu@sun.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>> H. Peter Anvin wrote:
>> Looks like the code doesn't check that the CPU *has* MTRRs...
> 
> so check it mtrr is there, also check if mem less 4G and is AMD as early

Why the check for < 4 GB?  The same thing applies to memory below the 4 
GB limit -- in fact, we've had a number of that kind of systems in the past.

	-hpa
