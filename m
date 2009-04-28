Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZD1U7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZD1U7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZD1U65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:58:57 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:48158 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbZD1U64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:58:56 -0400
Date: Tue, 28 Apr 2009 16:49:36 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       jesse.brandeburg@intel.com, netdev@vger.kernel.org, haoki@redhat.com,
       mchan@broadcom.com, davidel@xmailserver.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] poll: Avoid extra wakeups in select/poll
In-Reply-To: <49F767FD.2040205@cosmosbay.com>
Message-ID: <alpine.DEB.1.10.0904281629090.15947@qirst.com>
References: <alpine.DEB.1.10.0904241554100.29995@qirst.com> <49F3308B.1030507@cosmosbay.com> <20090426.020411.157511269.davem@davemloft.net> <49F43B8F.2050907@cosmosbay.com> <87ab60rh8t.fsf@basil.nowhere.org> <49F71B63.8010503@cosmosbay.com>
 <alpine.DEB.1.10.0904281501300.13862@qirst.com> <49F76174.6060009@cosmosbay.com> <alpine.DEB.1.10.0904281612560.13862@qirst.com> <49F767FD.2040205@cosmosbay.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Eric Dumazet wrote:

> The one that did improved your udpping 'bench' :)
>
> http://git2.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commitdiff;h=bf368e4e70cd4e0f880923c44e95a4273d725ab4

Well yes that is git2p1. The measurements that we took showed not much of
an effect as you see.






