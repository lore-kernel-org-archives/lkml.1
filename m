Return-Path: <linux-kernel-owner+w=401wt.eu-S966016AbXCFStt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966016AbXCFStt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966008AbXCFSts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:49:48 -0500
Received: from terminus.zytor.com ([192.83.249.54]:59808 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966004AbXCFStr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:49:47 -0500
Message-ID: <45EDB799.5080509@zytor.com>
Date: Tue, 06 Mar 2007 10:48:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: David Miller <davem@davemloft.net>, shemminger@linux-foundation.org,
       jengelh@linux01.gwdg.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC] div64_64 support II
References: <20070226143127.5c74bec9@freekitty> <p73slcnawh3.fsf@bingen.suse.de> <20070305155714.3abe1b5e@freekitty> <20070305.162551.41660347.davem@davemloft.net> <20070306140412.GA1470@one.firstfloor.org>
In-Reply-To: <20070306140412.GA1470@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> The problem with these algorithms that tradoff one or more
>> multiplies in order to avoid a divide is that they don't
>> give anything and often lose when both multiplies and
>> divides are emulated in software.
> 
> Actually on rereading this: is there really any Linux port
> that emulates multiplies in software? I thought that was only
> done on really small microcontrollers or smart cards; but anything
> 32bit+ that runs Linux should have hardware multiply, shouldn't it?

SPARC < v8 does multiplies using an MSTEP instruction.

	-hpa
