Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891Ab0ASG4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0ASG4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 01:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994Ab0ASG4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 01:56:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54358 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab0ASG4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 01:56:35 -0500
Message-ID: <4B5557A7.5000401@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 14:56:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: jidong xiao <jidong.xiao@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Where is proc_misc.c?
References: <4104961b1001182254x74f3fcd1r906de8f10c105f8a@mail.gmail.com>
In-Reply-To: <4104961b1001182254x74f3fcd1r906de8f10c105f8a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jidong xiao wrote:
> Hi,
> 
> Does anybody know what happend to fs/proc/proc_misc.c? The file is
> missing in 2.6.29. Seems like there was an cleanup, but i can't find
> the new location of the methods. Any help appreciated.
> 

$ git log -- fs/proc/proc_misc.c
commit 59c7572e82d69483a66eaa67b46548baeb69ecf4
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Mon Oct 6 14:49:39 2008 +0400

    proc: remove fs/proc/proc_misc.c

    Now that everything was moved to their more or less expected places,
    apply rm(1).

    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

