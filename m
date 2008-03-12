Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYCLWMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYCLWMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYCLWMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:12:03 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54260 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYCLWMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:12:01 -0400
Date: Wed, 12 Mar 2008 23:12:00 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Re: WAN: new PPP code for generic HDLC
In-Reply-To: <m33aqvsnyg.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.64.0803122311270.14822@fbirervta.pbzchgretzou.qr>
References: <m3prtzsszg.fsf@maximus.localdomain> <m3lk4nsskh.fsf@maximus.localdomain>
 <Pine.LNX.4.64.0803122032410.14822@fbirervta.pbzchgretzou.qr>
 <m33aqvsnyg.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 12 2008 21:10, Krzysztof Halasa wrote:
>
>> -static const char *code_names[CP_CODES] = {"0", "ConfReq", "ConfAck",
>> +static const char *const code_names[] = {"0", "ConfReq", "ConfAck",
>>  					   "ConfNak", "ConfRej", "TermReq",
>>  					   "TermAck", "CodeRej", "ProtoRej",
>>  					   "EchoReq", "EchoReply", "Discard"};
>
>The explicit sizes are there as a prevention.

You can keep them if you need, the main issue was const anyway.
