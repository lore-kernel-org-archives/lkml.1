Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbYELGxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbYELGxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 02:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbYELGwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 02:52:40 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:49526 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238AbYELGwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 02:52:39 -0400
Message-ID: <4827E930.3000008@krogh.cc>
Date: Mon, 12 May 2008 08:52:32 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
References: <20080507.141521.193714938.davem@davemloft.net>	<482498D5.9060008@krogh.cc>	<48258074.7060306@krogh.cc> <20080510.213431.193696750.davem@davemloft.net>
In-Reply-To: <20080510.213431.193696750.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jesper Krogh <jesper@krogh.cc>
> Date: Sat, 10 May 2008 13:01:08 +0200
> 
>> Any good suggestions about the "Transmit timed out" messages. It
>> currently leads to a system that "doesnt die" but doesnt respond within
>> 15 minutes of load of the network adapter.
> 
> It's likely some bug in the driver that hangs the card for whatever
> reason, which we'll need to work out.

Ok. I have been testing a bit more. It generally works fine, It seems
the "transmit timed out" thing was provoked by dd in the tests, because
it was creating a lot of small requests. (default bs=512).(over NFS).
When the  blocksize went up, the problem dissapered. (and the numer of
context-switches went down).

When the blocksize went up, the performance likewise raised to 615MB/s.
I haven't been able to get pass that number.

This is where one of the cpu's are settling at 100% load.

Jesper

-- 
Jesper
