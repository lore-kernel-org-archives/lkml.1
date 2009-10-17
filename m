Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbZJQBJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbZJQBJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 21:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZJQBJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 21:09:04 -0400
Received: from exprod6og103.obsmtp.com ([64.18.1.185]:34444 "HELO
	exprod6og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752449AbZJQBJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 21:09:03 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] net/ipv4/ipconfig.c: local symbols should be static
Date: Fri, 16 Oct 2009 21:09:07 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901E24572@mi8nycmail19.Mi8.com>
In-Reply-To: <20091016.180409.204538933.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] net/ipv4/ipconfig.c: local symbols should be static
Thread-Index: AcpOxbHTM18yeg7KQDu2AYeSMZlqogAAFVNg
References: <BD79186B4FD85F4B8E60E381CAEE190901E24569@mi8nycmail19.Mi8.com> <20091016.180409.204538933.davem@davemloft.net>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "David Miller" <davem@davemloft.net>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Oct 2009 01:09:07.0015 (UTC) FILETIME=[6CD94570:01CA4EC6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 16, 2009 6:04 PM, David Miller wrote:
>> The symbol ic_dev_xid is only used locally to track the device being
>> configured.  As such, it should be static.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> 1) Your patch doesn't apply to current sources.

Strange.  I just did a git pull this afternoon.

bigguiness@etch:~/src/git/linux-2.6$ git show
commit 2fdc246aaf9a7fa088451ad2a72e9119b5f7f029
Merge: 7c650a0 4997811
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Oct 16 10:13:58 2009 -0700

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp
    
    * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp:
      amd64_edac: fix DRAM base and limit extraction masks, v2

What tree should network patches be based on?

> 2) You need to CC: all networking patch submissions to
>    netdev@vger.kernel.org so that your patch gets properly
>    tracked at http://patchwork.ozlabs.org/project/netdev/list

Sorry about that.

Regards,
Hartley
