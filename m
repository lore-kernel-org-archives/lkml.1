Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbXLSSi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbXLSSi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 13:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbXLSSiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 13:38:19 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:38516 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbXLSSiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 13:38:19 -0500
Message-ID: <47696534.2060909@davidnewall.com>
Date: Thu, 20 Dec 2007 05:08:44 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Al Viro <viro@ftp.linux.org.uk>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
References: <47684DBD.6030502@rtr.ca> <20071218230016.GF8181@ftp.linux.org.uk> <20071218231404.GG8181@ftp.linux.org.uk> <47689608.3030503@rtr.ca> <4768973C.8020909@davidnewall.com> <47694B06.6090407@rtr.ca>
In-Reply-To: <47694B06.6090407@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> David Newall wrote:
>> Mark Lord wrote:
>>> But.. pity there's no mount flag override for smaller systems,
>>> where bind mounts might be more useful with link(2) actually working.
>>
>> I don't see it.  You always can make hard link on the underlying 
>> filesystem.  If you need to make it on the bound mount, that is, if 
>> you can't locate the underlying filesystem to make the hard link, you 
>> can use a symbolic link.
> ..
>
> Where people run into trouble with this, is when they simply go to
> move a huge file (DVD image) from one directory to another,
> where the target happens to be on a different bind point of the
> same underlying filesystem.

Does that prevent you from seeing the underlying filesystem?
