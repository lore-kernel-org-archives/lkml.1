Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbXFTPkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbXFTPkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbXFTPkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:40:05 -0400
Received: from qb-out-0506.google.com ([72.14.204.231]:31539 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbXFTPkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:40:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:x-mailer:x-operating-system;
        b=Oxz1wvPcNKDJ8GAbYTaQwoZvueN3xTJx/NTx6PygRas0+17NlJ0Oe7ZP5c71Ty7thFJ8XFUY+F1cxSpL1iAjQBm4tx3NoZeo/H6WxI+UI4HltmUIFRm24iNWp1vqOZ0lWITw2+wt8htm7xKQKJ4NLeOs3aVr1CegOPZadgA7QDo=
Date: Wed, 20 Jun 2007 23:46:10 +0800
From: Wang Zhenyu <zhen78@gmail.com>
To: Carlo Wood <carlo@alinoe.com>, Wang Zhenyu <zhenyu.z.wang@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, lethal@linux-sh.org, y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
Message-ID: <20070620154610.GA2802@localhost.localdomain>
References: <20070618181225.GB8054@alinoe.com> <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org> <20070618195415.GA7481@alinoe.com> <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org> <20070618225009.GE13538@alinoe.com> <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org> <20070619233716.GA5779@alinoe.com> <20070620011521.GB2856@zhen-devel.sh.intel.com> <20070620014227.GA4090@zhen-devel.sh.intel.com> <20070620140237.GB5524@alinoe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620140237.GB5524@alinoe.com>
User-Agent: Mutt/1.4.2.2i
X-Mailer: mutt
X-Operating-System: Linux 2.6.21-rc6 i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.20 16:02:37 +0000, Carlo Wood wrote:
> 
> and I am not sure if you will consider the:
> 
> agpgart: Failed to find bridge device (chip_id: 29a2)
> 
> a bug.

yeah, the error message needs to be fixed only if AGP cap
exists. I was checking with other GMCH data sheets, we'd better 
disable AGP for chip that has no AGP port. I will send out
another patch later.
