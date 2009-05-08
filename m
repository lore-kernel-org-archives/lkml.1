Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbZEHH5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbZEHH5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZEHH5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:57:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58043 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbZEHH5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:57:04 -0400
Message-ID: <4A03E579.8030201@redhat.com>
Date: Fri, 08 May 2009 10:55:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <20090507233503.GA9103@amt.cnet> <20090507234311.GA9517@amt.cnet>
In-Reply-To: <20090507234311.GA9517@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti wrote:
> Also it would be interesting to see the MMIO comparison with EPT/NPT,
> it probably sucks much less than what you're seeing.
>   

Why would NPT improve mmio?  If anything, it would be worse, since the 
processor has to do the nested walk.

Of course, these are newer machines, so the absolute results as well as 
the difference will be smaller.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

