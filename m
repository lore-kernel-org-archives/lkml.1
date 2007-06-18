Return-Path: <linux-kernel-owner+w=401wt.eu-S933637AbXFRW6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbXFRW6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932425AbXFRW6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:58:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58789 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932189AbXFRW6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:58:16 -0400
Date: Mon, 18 Jun 2007 15:57:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Carlo Wood <carlo@alinoe.com>
cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
       y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
In-Reply-To: <20070618225009.GE13538@alinoe.com>
Message-ID: <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org>
References: <20070617182254.GA17595@alinoe.com> <20070617195805.GA6125@alinoe.com>
 <20070617214905.GA6207@alinoe.com> <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org>
 <20070618181225.GB8054@alinoe.com> <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org>
 <20070618195415.GA7481@alinoe.com> <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org>
 <20070618225009.GE13538@alinoe.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Jun 2007, Carlo Wood wrote:
> 
> Conclusion: the weird behaviour that you think was wrong is
> totally due to git 1.4.4.4.

Ok. I'll bounce a note to Junio just due to curiosity in case he goes 
"ahh, yeah, it was that known bug", but I'll otherwise ignore this.

Git-1.5.x is such a radically better version (not because it fixes this 
bug, but because we fixed a number of other issues, notably some very 
basic usability things), that I think any git users should really upgrade 
to a newer version.

IOW, there's simply no reason to stay on anything older (git has always 
been backwards compatible since very early on, so upgrading to a newer 
version of git won't break anything, although some of the new UI's might 
obviously cause you to do things differently).

> I'll redo the bisect with this new git.

Thanks,

		Linus
