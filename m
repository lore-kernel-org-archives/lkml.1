Return-Path: <linux-kernel-owner+w=401wt.eu-S1030685AbXCLQyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030685AbXCLQyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030687AbXCLQyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:54:04 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:21221 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030685AbXCLQyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:54:03 -0400
Message-ID: <45F588DE.3000309@sw.ru>
Date: Mon, 12 Mar 2007 20:07:42 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Dave Hansen <hansendc@us.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@sw.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru>	 <m14porwq1c.fsf@ebiederm.dsl.xmission.com>  <45F57E7D.6080604@sw.ru> <1173718208.11945.54.camel@localhost.localdomain>
In-Reply-To: <1173718208.11945.54.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2007-03-12 at 19:23 +0300, Kirill Korotaev wrote:
> 
>>For these you essentially need per-container page->_mapcount counter,
>>otherwise you can't detect whether rss group still has the page in question being mapped
>>in its processes' address spaces or not. 
> 
> 
> What do you mean by this?  You can always tell whether a process has a
> particular page mapped.  Could you explain the issue a bit more.  I'm
> not sure I get it.
When we do charge/uncharge we have to answer on another question:
"whether *any* task from the *container* has this page mapped", not the
"whether *this* task has this page mapped".

Thanks,
Kirill
