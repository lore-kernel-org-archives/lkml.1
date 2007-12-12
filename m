Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbXLLTnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbXLLTnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbXLLTno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:43:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46538 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbXLLTnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:43:43 -0500
Message-ID: <476039C7.7030602@zytor.com>
Date: Wed, 12 Dec 2007 11:43:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Kyle McMartin <kyle@mcmartin.ca>, Rene Herman <rene.herman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, rol@as2917.net,
       Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <20071212052304.GB20883@fattire.cabal.ca> <476035C0.1040708@zytor.com> <20071212193213.GF21864@one.firstfloor.org>
In-Reply-To: <20071212193213.GF21864@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> "=A" works on 32-bit systems (only), obviously, and gcc will generally 
>> produce slightly better code as a result (gcc could really use a 
>> register renaming/copy propagation step *after* multi-register entities 
> 
> I believe gcc 4.3 (or maybe 4.2) does that already -- it splits them much 
> earlier.

Probably 4.3, then.  I don't see 4.2 doing that, or at least not very 
successfully.  Which is fine, I'm sure they had bigger fish to fry. 
Good to hear it has gotten some attention recently.

	-hpa
