Return-Path: <linux-kernel-owner+w=401wt.eu-S1751922AbXCTX4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbXCTX4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 19:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbXCTX4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 19:56:10 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:52048 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbXCTX4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 19:56:08 -0400
Date: Tue, 20 Mar 2007 17:55:31 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: UDP packets scheduling
In-reply-to: <fa.Mj0BY4rypcd66zFbzfAQxZCpUVk@ifi.uio.no>
To: Lukas Hejtmanek <xhejtman@mail.muni.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Message-id: <46007473.7070001@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-2; format=flowed
Content-transfer-encoding: 7bit
References: <fa.CWur1AzeHpCwg8xikmKYIrHD+vg@ifi.uio.no>
 <fa.XuXSOUdBq9+oYcuagtcjLic4XjE@ifi.uio.no>
 <fa.Mj0BY4rypcd66zFbzfAQxZCpUVk@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> On Tue, Mar 20, 2007 at 06:52:51PM +0100, Andi Kleen wrote:
>>> Flow control must be turned off for some other reason.
>> That's your fundamental problem. Fix that. 
>>
>> Even if you get the rate right there can be many reasons why timing 
>> gets disrupted temporarily and to recover from any of this you need
>> working flow control.
> 
> How do you want to enable wire/fibre flow control, e.g., from Europe to USA?
> You are not guaranteed any hardware based flow control.
> 
> And as of software flow control, you need precise timing of UDP packets to
> keep desired packet rate. How to do it at speeds about 5.5Gbps, that is my
> question.

Why is it necessary to avoid bursting? There should be enough buffering 
along the chain to avoid packet loss with reasonable burst sizes.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

