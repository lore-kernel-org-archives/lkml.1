Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbXJJQcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbXJJQcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbXJJQcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:32:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51867 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbXJJQcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:32:12 -0400
Message-ID: <470CFE65.80800@zytor.com>
Date: Wed, 10 Oct 2007 09:31:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kevin <spaceman__spiff@cox.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ARPM shutdown oops (Re: [stable] [patch 09/12] Fix SMP poweroff
 hangs)
References: <20071008180406.052382073@mini.kroah.org> <alpine.LFD.0.99.0710100133590.5040@localhost.localdomain> <alpine.LFD.0.999.0710092224000.3838@woody.linux-foundation.org> <200710092359.47144.spaceman__spiff@cox.net> <alpine.LFD.0.999.0710100747120.3838@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710100747120.3838@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> We did have some APM *detection* changes, and maybe APM wasn't even 
> detected for you before, or it was detected differently. That would be due 
> to the bootup changes, I'm Cc'ing Peter Anvin (and the kernel mailing 
> list, in case somebody else see a pattern to this).
> 

Well, I did have exactly one bug report about APM, and that was a user 
who had inadvertently flipped his CONFIG_APM setting (from on to off in 
his particular case -- it was a 10-year-old machine without ACPI.)

	-hpa
