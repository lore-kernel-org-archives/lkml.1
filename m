Return-Path: <linux-kernel-owner+w=401wt.eu-S1760518AbZCPS1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760518AbZCPS1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbZCPS1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:27:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbZCPS1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:27:04 -0400
Message-ID: <49BE98FB.9050406@zytor.com>
Date: Mon, 16 Mar 2009 11:22:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <49BE7A84.2030503@goop.org> <49BE84D6.3010006@kernel.org> <49BE9248.6050707@goop.org> <49BE97B0.8000004@kernel.org>
In-Reply-To: <49BE97B0.8000004@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> need more extra check for INIT_MAP_SIZE calculating...
> 

The original calculation was designed to map enough memory that we could 
map all of lowmem.  That is, two page table levels removed from actual 
lowmem, which put the overhead in the order of kilobytes (16 K in the 
wost case.)  Something similar is definitely needed.

	-hpa

