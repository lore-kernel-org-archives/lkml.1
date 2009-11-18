Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbZKRVAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbZKRVAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757748AbZKRVAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:00:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33057 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837AbZKRVAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:00:13 -0500
Message-ID: <4B046038.4040608@zytor.com>
Date: Wed, 18 Nov 2009 12:59:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Matteo Croce <technoboy85@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <20091113162301.GU15157@caffeine.csclub.uwaterloo.ca> <20091113165730.0b9b2676@lxorguk.ukuu.org.uk> <20091113192412.GY15157@caffeine.csclub.uwaterloo.ca> <20091113212148.5cb829d4@lxorguk.ukuu.org.uk> <20091116175006.GA15157@caffeine.csclub.uwaterloo.ca> <20091117115929.4ba23c49@lxorguk.ukuu.org.uk> <7332.1258476527@turing-police.cc.vt.edu> <20091117172515.GI15159@caffeine.csclub.uwaterloo.ca> <4B02DE4E.4070504@zytor.com> <20091117183357.GH15157@caffeine.csclub.uwaterloo.ca> <20091118202109.GJ15159@caffeine.csclub.uwaterloo.ca>
In-Reply-To: <20091118202109.GJ15159@caffeine.csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2009 12:21 PM, Lennart Sorensen wrote:
> 
> OK, I added a bit of debuging print statements to msr.c and I find that
> calling rdmsr 0x1810 returns error 0xfffffff2 (-14 that is).
> 

What this means is the RDMSR instruction traps -- the CPU doesn't
recognize this as a valid MSR.

	-hpa
