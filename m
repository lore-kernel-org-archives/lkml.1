Return-Path: <linux-kernel-owner+w=401wt.eu-S932466AbXJZXqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbXJZXqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760286AbXJZXql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:46:41 -0400
Received: from palrel12.hp.com ([156.153.255.237]:33239 "EHLO palrel12.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759694AbXJZXqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:46:39 -0400
Message-ID: <47227C5C.1070507@hp.com>
Date: Fri, 26 Oct 2007 16:46:36 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: ebiederm@xmission.com, bunk@kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] always export sysctl_{r,w}mem_max
References: <20071026230807.GE30533@stusta.de>	<m1zly5wjie.fsf@ebiederm.dsl.xmission.com>	<472278E3.4000909@hp.com> <20071026.163958.171785530.davem@davemloft.net>
In-Reply-To: <20071026.163958.171785530.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> If DLM really wants minimum, it can use SO_SNDBUFFORCE and
> SO_RCVBUFFORCE socket options and use whatever limits it
> likes.
> 
> But even this is questionable.

Drift...

Is that something netperf should be using though?  Right now it uses the regular 
SO_[SND|RCV]BUF calls and is at the mercy of sysctls.  I wonder if it would be 
better to have it use their FORCE versions to make life easier on the 
benchmarker - such as myself - who has an unfortunate habit of forgetting to 
update sysctl.conf :)

rick jones
