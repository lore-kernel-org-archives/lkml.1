Return-Path: <linux-kernel-owner+w=401wt.eu-S1761178AbXEQGcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761178AbXEQGcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbXEQGcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:32:36 -0400
Received: from terminus.zytor.com ([192.83.249.54]:44907 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXEQGcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:32:35 -0400
Message-ID: <464BF6D9.2020802@zytor.com>
Date: Wed, 16 May 2007 23:31:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christian <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
References: <464B9D2C.7040704@cv-sv.de> <alpine.LFD.0.98.0705161750350.3890@woody.linux-foundation.org> <464BAF07.9020003@cv-sv.de> <alpine.LFD.0.98.0705161920410.3890@woody.linux-foundation.org> <464BC67F.7080707@zytor.com> <alpine.LFD.0.98.0705162012340.3890@woody.linux-foundation.org> <464BDF58.2090907@zytor.com> <20070517061804.GM30166@redhat.com>
In-Reply-To: <20070517061804.GM30166@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> 
> agreed, though we'll still need something for .22 (I'm assuming your rework
> isn't intended for .22)
> 

My suggestion would be to take out the CPU verification code for .22 and
merge the rewrite in .23.

	-hpa
