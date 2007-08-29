Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbXH2Rbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbXH2Rbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 13:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbXH2Rbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 13:31:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53197 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbXH2Rbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 13:31:37 -0400
Message-ID: <46D5ACA1.3090503@zytor.com>
Date: Wed, 29 Aug 2007 10:28:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible
 fashion.
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>	<20070828230459.GA15937@infradead.org>	<m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com>	<46D4CC81.4060400@zytor.com>	<m1d4x7aysz.fsf@ebiederm.dsl.xmission.com>	<20070829114604.242b976c@the-village.bc.nu> <m1absa5kid.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1absa5kid.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> My hypothesis.  No one cares now.
> 
> My observation. The way we have been maintaining the binary sysctl
> side of things using it is asking for your application to be broken in
> subtle and nasty ways.
> 

I suspect the right thing to do is simply to make a list of the 
supported binary sysctls, and automatically verify those numbers.  Doing 
that would alleviate these concerns, wouldn't break anything, and isn't 
really that hard to do.

	-hpa
