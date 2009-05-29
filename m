Return-Path: <linux-kernel-owner+w=401wt.eu-S1761465AbZE2S0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465AbZE2S0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 14:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZE2S0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 14:26:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33929 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbZE2S0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 14:26:22 -0400
Message-ID: <4A2028BD.8050408@redhat.com>
Date: Fri, 29 May 2009 14:26:05 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com
Subject: Re: [PATCH] [1/16] HWPOISON: Add page flag for poisoned pages
References: <200905271012.668777061@firstfloor.org> <20090527201226.CCCBB1D028F@basil.firstfloor.org> <20090527221510.5e418e97@lxorguk.ukuu.org.uk> <20090528075416.GY1065@one.firstfloor.org> <4A2008F0.1070304@redhat.com> <20090529163757.GX1065@one.firstfloor.org> <4A200E98.20306@redhat.com> <20090529182440.GY1065@one.firstfloor.org>
In-Reply-To: <20090529182440.GY1065@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Fri, May 29, 2009 at 12:34:32PM -0400, Rik van Riel wrote:
>>> They should just check for poisoned pages. 
>> #define PagePoisoned(page) (PageReserved(page) && PageWriteback(page))
> 
> I don't know what the point of that would be. An exercise in code
> obfuscation?

Saving a page flag.

-- 
All rights reversed.
