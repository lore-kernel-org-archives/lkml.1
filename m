Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbZDUWDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbZDUWDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 18:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbZDUWDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 18:03:00 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:53720 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752967AbZDUWDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 18:03:00 -0400
Message-ID: <49EE42CC.7070002@opengridcomputing.com>
Date: Tue, 21 Apr 2009 17:03:56 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Wolfram Strepp <wstrepp@gmx.de>
Subject: Re: [BUG] rbtree bug with mmotm 2009-04-14-17-24
References: <20090421184223.GP19637@balbir.in.ibm.com>
In-Reply-To: <20090421184223.GP19637@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Balbir Singh wrote:
> Hi, Andrew,
>
> I did a quick check on lkml to see if someone reported this issue
> already, I could not find any reports. I am beginning to see several
> of these on my machine. I saw recent refactoring of rbtrees, I've
> cc'ed Wolfram Strepp.
>
>   


I see a similar crash (null ptr deref in rb_erase()) booting up 
2.6.30-rc2/x86_64/centos 5.3 distro.

Steve.


