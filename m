Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbXF3NIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbXF3NIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 09:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbXF3NIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 09:08:00 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56715 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998AbXF3NH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 09:07:59 -0400
Message-ID: <468652E2.4050901@zytor.com>
Date: Sat, 30 Jun 2007 08:56:02 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Ram Pai <linuxram@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] VFS: Augment /proc/mount with subroot and shared-subtree
References: <20070620210343.GQ21478@ftp.linux.org.uk> <46799A31.10301@zytor.com> <1182442837.3342.13.camel@ram.us.ibm.com> <467AB5EE.3030909@zytor.com> <1182494654.2812.22.camel@ram.us.ibm.com> <467B7509.8010106@zytor.com> <1182497690.2812.54.camel@ram.us.ibm.com> <467B7F6F.4030007@zytor.com> <20070625214640.GC29058@ram.us.ibm.com> <1182808816.2816.7.camel@ram.us.ibm.com> <20070630094446.GB22889@infradead.org>
In-Reply-To: <20070630094446.GB22889@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>>
>> The following additional fields are appended to each record
>> in /proc/mounts
> 
> NACK.  Adding anything to the format will confuse the hell out of
> existing parsers.  We really want something like your /proc/<pid>/mounts_new,
> except mounts_new should have a better name (/proc/<pid>/ns anyone? :))
> 

Is that conjecture, or do you have evidence to that effect?  Most users 
of this file are using it via the glibc interfaces, and there probably 
aren't all that many users of it in the first place.

This was debated in some detail earlier in this thread.

(Note: this patch is still wrong, since it appends the new fields in the 
wrong place.)

	-hpa
