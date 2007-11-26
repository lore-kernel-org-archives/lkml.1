Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbXKZVTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbXKZVTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbXKZVT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:19:29 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:31707 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbXKZVT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:19:28 -0500
Message-ID: <474B37F5.4070104@oracle.com>
Date: Mon, 26 Nov 2007 13:17:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] x86 allnoconfig memory model
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <20071126111320.69d0aead.randy.dunlap@oracle.com> <Pine.LNX.4.64.0711261127250.23080@schroedinger.engr.sgi.com> <20071126124730.34c43da1.randy.dunlap@oracle.com> <Pine.LNX.4.64.0711261258480.25688@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711261258480.25688@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Mon, 26 Nov 2007, Randy Dunlap wrote:
> 
>> This patch allows allnoconfig to build cleanly.
> 
> Well this sortof works.
> 
> One can again select a memory model but there is only one to choose from.

At least the help text allows / explains that.

> It would be best if the memory model selection would not occur.

My attempt at that gave a warning from kconfig:

mm/Kconfig:70:warning: defaults for choice values not supported


Other than that, it seemed to work.
Maybe someone else can have a go at it.

-- 
~Randy
