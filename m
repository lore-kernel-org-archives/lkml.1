Return-Path: <linux-kernel-owner+w=401wt.eu-S1764046AbYBHRV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764046AbYBHRV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762833AbYBHRUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:20:01 -0500
Received: from mail.syneticon.net ([213.239.212.131]:60685 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761624AbYBHRT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:19:59 -0500
Message-ID: <47AC8F34.3020705@wpkg.org>
Date: Fri, 08 Feb 2008 18:19:48 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       Horms <horms@verge.net.au>
Subject: Re: why kexec insists on syncing with recent kernels?
References: <47AB120A.1000600@wpkg.org>	<20080207163752.GD11969@redhat.com>	<47AB38E2.9050509@wpkg.org>	<20080208160408.GB18782@redhat.com> <20080208090407.4ab240f1.randy.dunlap@oracle.com>
In-Reply-To: <20080208090407.4ab240f1.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap schrieb:

(...)

>> Even if you did -f, it must have shutdown the network. I think somehow
>> in latest kernels there is some dependency on network and that's why
>> not shutting down network in this case is helping you.
> 
> I'm seeing NFS mounts take forever to unmount (at shutdown/reboot).
> (forever => 1 hour ... or never completes)
> 
> Is this similar to the problem that the OP is asking about?

Is it a diskless station?

Even in not, just make sure you don't shut the network down before NFS 
is actually unmounted...?


-- 
Tomasz Chmielewski
http://wpkg.org
