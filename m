Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbYJ2KAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbYJ2KAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 06:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYJ2KAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 06:00:46 -0400
Received: from main.gmane.org ([80.91.229.2]:33389 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbYJ2KAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 06:00:45 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Thomas Guyot-Sionnest <dermoth@aei.ca>
Subject: Re: CFQ Idle class slowing down everything?
Date: Wed, 29 Oct 2008 06:00:34 -0400
Message-ID: <49083442.9050500@aei.ca>
References: <gcm0sv$ra4$1@ger.gmane.org> <20081014121859.4778abcf.akpm@linux-foundation.org> <490226C9.4000406@aei.ca> <490754F1.1080607@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: dsl-216-221-37-62.aei.ca
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
In-Reply-To: <490754F1.1080607@cfl.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/08 02:07 PM, Phillip Susi wrote:
> Thomas Guyot-Sionnest wrote:
>> On 14/10/08 03:18 PM, Andrew Morton wrote:
>>>> When "idle", the slave do mostly random writes: about 15 rtps and 200
>>>> wtps. For testing I ended up running dd to read files from disk to
>>>> /dev/null while avoiding the system cache (had 42GB of data to read
> 
> Just thought I would point out that dd is, in fact, dirtying the buffer
> cache since you don't pass flag=direct.
> 

Yes, I know that, though at each run I read a different chunk so it
shouldn't affect my benchmark.

The point to note is that even though the CFQ Idle class seems to work
now (it does reduce the IO load instead of making overall IO a lot
slower), it's sill having more impact on my system than using the
deadline scheduler which has no class at all.

--
Thomas

