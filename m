Return-Path: <linux-kernel-owner+w=401wt.eu-S1750710AbXBMPMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750710AbXBMPMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750731AbXBMPMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:12:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:63363 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbXBMPMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:12:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH x86 for review III] [1/29] i386: avoid gcc extension
Date: Tue, 13 Feb 2007 16:11:14 +0100
User-Agent: KMail/1.9.5
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Segher Boessenkool <segher@kernel.crashing.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702131611.15172.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18uPhqAFO0HZzSp7gL3QgSFYe2GvzeT0ewnmSkUGcAU4LM+BOylQ2YSHYuv+2Ld/RxF16DQPoy5KNY4GlvR/s1bCuXDC4bDIUWfRuQsMMQjDw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 February 2007 17:51, Andi Kleen wrote:
> setcc() in math-emu is written as a gcc extension statement expression
> macro that returns a value.  However, it's not used that way and it's not
> needed like that, so just make it a do-while non-extension macro so that we
> don't use an extension when it's not needed.
> 

The patch looks good but it doesn't match the description any more, since
you now use a function...
