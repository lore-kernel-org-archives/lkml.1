Return-Path: <linux-kernel-owner+w=401wt.eu-S1763171AbYHDWJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763171AbYHDWJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYHDWJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:09:32 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44310 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbYHDWJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:09:32 -0400
Message-ID: <48977D58.8010303@cs.helsinki.fi>
Date: Tue, 05 Aug 2008 01:06:16 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Christoph Lameter <cl@linux-foundation.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SLUB: detach SLUB_DEBUG and SYSFS
References: <20080801000405.GA7072@martell.zuzino.mipt.ru> <48941C2F.8010406@cs.helsinki.fi> <489702B9.5030204@linux-foundation.org> <48970DDD.4040607@cs.helsinki.fi> <20080804220247.GA10159@martell.zuzino.mipt.ru>
In-Reply-To: <20080804220247.GA10159@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> OK, I'll test-compile it to death.
> 
> For now, do you agree that SYSFS=n users shouldn't be discriminated
> against poisoning?
> 
> As real world situation, NET_NS feature which is currently in
> active development doesn't work with SYSFS, so it was a bit of cold
> shower to realise that I did much testing of conntracking in netns
> without poisoning. :-(

I'm okay with that as long as it doesn't break the build :-)
