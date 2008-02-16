Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbYBPOOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbYBPOOE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 09:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbYBPONx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 09:13:53 -0500
Received: from rtr.ca ([76.10.145.34]:3486 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544AbYBPONw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 09:13:52 -0500
Message-ID: <47B6EF9D.5090804@rtr.ca>
Date: Sat, 16 Feb 2008 09:13:49 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, jengelh@computergmbh.de, matthew@wil.cx,
       randy.dunlap@oracle.com, daniel.ritz-ml@swissonline.ch,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk,
 take #3
References: <12028937731333-git-send-email-htejun@gmail.com>	<20080213155701.48871761.akpm@linux-foundation.org>	<47B38E13.1060503@gmail.com>	<20080213170950.86945835.akpm@linux-foundation.org>	<47B398B3.40308@gmail.com>	<47B4EFAB.2040102@gmail.com>	<20080214182700.a9a706e9.akpm@linux-foundation.org>	<47B4FA9C.9080809@gmail.com> <20080214185003.9ca9a640.akpm@linux-foundation.org> <47B50420.3060403@gmail.com>
In-Reply-To: <47B50420.3060403@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Andrew Morton wrote:
>>> So, I guess it's NACK w/o suggested alternatives, right?
>> I wouldn't nack without good reasons, and I have none here.  I don't have
>> very strong opinions either way.
> 
> I was just wondering whether I should just go with snprintf dancing in
> eh_link_report, which does make sense if not many need merging printk.
..

Any chance you could poke through snprintf() and look for the off-by-one bug
on the return result?  (I think it happens when "n" is exceeded).

:)
