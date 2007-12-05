Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbXLEU1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbXLEU1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 15:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbXLEU1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 15:27:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbXLEU1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 15:27:33 -0500
Message-ID: <47570B0A.6040404@redhat.com>
Date: Wed, 05 Dec 2007 15:33:14 -0500
From: Dave Anderson <anderson@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030611
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exec: allow > 2GB executables to run on 64-bit systems
References: <4756C590.9080301@redhat.com> <p73fxyhj5f7.fsf@bingen.suse.de> <475702E7.1000607@redhat.com> <20071205195637.GA20595@one.firstfloor.org>
In-Reply-To: <20071205195637.GA20595@one.firstfloor.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>I agree in theory.  We've only seen instances on 64-bitters...
> 
> 
> I think that's because gcc does not support the medium/large code models
> for i386. Although in theory someone could create an executable with
> a large enough .data.
> 
> -Andi

Or perhaps huge debuginfo section(s)?  The x86_64 instance
had 2.5GB .debug_macinfo DWARF section.

Dave


