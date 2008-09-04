Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbYIDTgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbYIDTgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYIDTgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:36:23 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:48662 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbYIDTgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:36:22 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Grant Coady <gcoady.lk@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       reiserfs-devel@vger.kernel.org
Subject: Re: reiserfs  BUG in 2.6.27-rc5
Date: Fri, 05 Sep 2008 05:36:03 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <aud0c4tdtnhbjensn5mgdkl1f3cjigkmt6@4ax.com>
References: <48BEBCCB.9000506@oracle.com> <hs9ub49fbs1uu11540i0nmdeh143sqgo7f@4ax.com> <20080903192037.e39fa931.randy.dunlap@oracle.com>
In-Reply-To: <20080903192037.e39fa931.randy.dunlap@oracle.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008 19:20:37 -0700, Randy Dunlap <randy.dunlap@oracle.com> wrote:

>On Thu, 04 Sep 2008 10:12:38 +1000 Grant Coady wrote:
>
>> On Wed, 03 Sep 2008 09:35:23 -0700, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> 
>> >Running fsx-linux on x86_64.
>> 
>> Cannot duplicate here, can you tell me which fsx-linux (url) and how 
>> called?  I'm running slamd64-12.1 on reiserfs3 here.
>
>
>fsx-linux from akpm's ext3-tools tarball which is here:
>  http://www.zip.com.au/~akpm/linux/patches/stuff/ext3-tools.tar.gz
>
>
>Run command is (roughly, it's a large script with lots of options):
>
>fsx-linux -l 100M -N 10000 -S 0 /tester/fsxtestfile

Left:
grant@pooh64:~$ fsx-linux -l 100M  -S 0 linux/testing/fsx
...
^Csignal 2
testcalls = 26195489

running overnight, nothing in logs, .config and dmesg on:
  http://bugsplatter.id.au/kernel/boxen/pooh64/  {config,dmesg}-2.6.27-rc5a

Grant.
>
>
>---
>~Randy
>Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
>http://linuxplumbersconf.org/

