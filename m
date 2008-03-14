Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbYCNR5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbYCNR5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 13:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbYCNR5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 13:57:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbYCNR5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 13:57:14 -0400
Message-ID: <47DABBAF.4040005@redhat.com>
Date: Fri, 14 Mar 2008 13:53:51 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071018)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: drepper@redhat.com, viro@ZenIV.linux.org.uk, bharata@linux.vnet.ibm.com,
       libc-alpha@sourceware.org, jblunck@suse.de, ezk@cs.sunysb.edu,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de,
       cmm@us.ibm.com, haveblue@us.ibm.com
Subject: Re: [RFC] Union mount readdir support in glibc
References: <20080311055527.GA7256@in.ibm.com> <47D9F6CC.6010009@redhat.com> <20080314053925.GA10722@ZenIV.linux.org.uk> <47DA257C.9060409@redhat.com> <E1Ja5Tf-0003Op-Fi@pomaz-ex.szeredi.hu>
In-Reply-To: <E1Ja5Tf-0003Op-Fi@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>>> Actually, do we really need it other than to 0 and to current position
>>> (i.e. full rewind and a no-op)?
>>>       
>> Ever heard of the little function "telldir"?
>>     
>
> Actually, telldir/seekdir is already broken for some filesystems (NFS
> comes to mind).  POSIX was really crazy to require a working seekdir
> implementation, and userspace should quickly start _not_ using it.
>
>   

What makes you think that telldir/seekdir don't work for NFS?  The over the
wire protocols clearly take values which could be retrieved and stored via
those interfaces.

       ps

> The more new filesystems it doesn't work, the better, IMHO.
>
> Miklos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

