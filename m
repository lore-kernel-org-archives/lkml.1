Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZHFJEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZHFJEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 05:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZHFJEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 05:04:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33592 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbZHFJEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 05:04:50 -0400
Message-ID: <4A7A9C91.6070002@redhat.com>
Date: Thu, 06 Aug 2009 17:04:17 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andi Kleen <andi@firstfloor.org>, Bernhard Walle <bwalle@suse.de>
Subject: Re: [Patch 0/7] Implement crashkernel=auto
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>	<m1eirqtmey.fsf@fess.ebiederm.org>	<20090805140408.GJ7259@hmsreliant.think-freely.org>	<m1skg5vpgg.fsf@fess.ebiederm.org> <4A7A3A78.7080200@redhat.com>	<m1y6pxr737.fsf@fess.ebiederm.org> <4A7A506B.2060008@redhat.com>	<m1ljlxsiox.fsf@fess.ebiederm.org> <4A7A70E5.2010204@redhat.com>	<m1bpmtqxjh.fsf@fess.ebiederm.org> <4A7A7A0F.6070906@redhat.com>	<m1iqh1nxv3.fsf@fess.ebiederm.org> <m13a85nxab.fsf@fess.ebiederm.org>
In-Reply-To: <m13a85nxab.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Hmm.  I half take it back.  How is crashkernel=auto and then shrinking
> the reserved size better than the extended syntax Bernhard Walle
> introduced nearly two years ago?
>   

You mean something like crashkernel=512M-2G:64M,2G-:128M?
Isn't it longer and more complex than "crashkernel=auto" for an end user?

Hmm, this makes me to think that "crashkernel=auto" can be a replacement 
for that extended syntax...

