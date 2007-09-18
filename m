Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbXIRDAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbXIRDAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 23:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbXIRDAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 23:00:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:19028 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbXIRDAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 23:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=G/010coKEuWHcCZRtYocZFb3uMC5t6PxpTS60JYT6udrl3i2G20grxHcQ34DDLX5reH+3M0Smehc/jIcyoa0NNV7cIvbnopG0RZnjWvFBDMdfS6vhbvXRbU2Al17llpSUH8Za7yK4coBqTq1azitfIMGT8QwqebtKltzcsmazDk=
Date: Tue, 18 Sep 2007 10:59:19 +0800
From: lepton <ytht.net@gmail.com>
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
	To:	"YOSHIFUJI Hideaki /  =?ISO-8859-1?Q?=20=1B$B5HF#1QL@=1B(B=22?= <yoshfuji@linux-ipv6.org>"
			^-missing closing '"' in token
Cc: ytht.net@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH] 2.6.22.6 NETWORKING [IPV4]: Always use source addr in skb to reply packet
Message-ID: <20070918025919.GA16136@router.lepton.home>
References: <20070918021617.GA15540@router.lepton.home> <20070917.192044.48396034.davem@davemloft.net> <20070918.112644.28694997.yoshfuji@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918.112644.28694997.yoshfuji@linux-ipv6.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)

Hi,
  sorry for my previous email.
  What I mean is icmp_reply and ip_send_reply
in some situation will send out packets with wrong 
DESTINATION address.  the source address is always
correct.
