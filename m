Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbXF0Lkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbXF0Lkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 07:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbXF0Lko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 07:40:44 -0400
Received: from mondriaan.macroscoop.nl ([82.94.9.2]:2346 "EHLO
	mondriaan.macroscoop.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbXF0Lkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 07:40:43 -0400
Message-ID: <46824CA5.2020908@macroscoop.nl>
Date: Wed, 27 Jun 2007 13:40:21 +0200
From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706251434.43863.jesse.barnes@intel.com> <46823F71.6060200@macroscoop.nl> <20070627112216.GA31708@one.firstfloor.org>
In-Reply-To: <20070627112216.GA31708@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

> That's impossible. Either it limited your RAM or it didn't change anything.

OK, maybe it's cosmetic, but I would not expect a negative number

With old BIOS it printed
**** MTRRs don't cover all of memory, trimmed 196608 pages

with new BIOS it prints
**** MTRRs don't cover all of memory, trimmed -65536 pages

Pim
