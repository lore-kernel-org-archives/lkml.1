Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbYFASvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbYFASvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 14:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbYFASu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 14:50:58 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53428 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbYFASur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 14:50:47 -0400
Date: Sun, 1 Jun 2008 20:50:46 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: David Schwartz <davids@webmaster.com>
cc: linux-kernel@vger.kernel.org
Subject: RE: Question regarding TCP behavior
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEFDNAAC.davids@webmaster.com>
Message-ID: <alpine.LNX.1.10.0806012050230.4055@fbirervta.pbzchgretzou.qr>
References: <MDEHLPKNGKAHNMBLJOLKGEFDNAAC.davids@webmaster.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-05-29 18:56, David Schwartz wrote:
>> Greetings.
>>
>> I have a question about how linux's TCP stack behaves.
>> I apologize if this is not the right place to ask this question and
>> please redirect me.
>>
>> When a TCP end point (A) sends x bytes of data to the other end point (B),
>> does B immediately ACK the received bytes or will it do so only
>> when the data
>> is passed to the upper layer ?
>>
>>
>> Thanks
>> Thomas
>
>If the TCP connection was idle and there is no unacknowledged data in either
>direction, the answer is neither.
>
>Acknowledging the data immediately is wasteful.[...]

And for everything else, there is the PSH bit. (I assume?)
