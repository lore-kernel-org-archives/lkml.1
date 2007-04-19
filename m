Return-Path: <linux-kernel-owner+w=401wt.eu-S1766886AbXDSRP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766886AbXDSRP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766888AbXDSRP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:15:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766886AbXDSRP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:15:56 -0400
Message-ID: <4627A3C3.8050108@redhat.com>
Date: Thu, 19 Apr 2007 13:15:47 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Marat Buharov <marat.buharov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: why UDF have so ugly filesize limit?
References: <698310e10704190655j1263035bi77c5f551db510646@mail.gmail.com>	<46279F3B.8050807@redhat.com> <20070419181221.59c3c7bd@the-village.bc.nu>
In-Reply-To: <20070419181221.59c3c7bd@the-village.bc.nu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 19 Apr 2007 12:56:27 -0400
> Chuck Ebbert <cebbert@redhat.com> wrote:
> 
>> Marat Buharov wrote:
>>> from fs/udf/super.c:
>>> in function udf_fill_super
>>> sb->s_maxbytes = 1<<30; (1 GB)
>>>
>>> Why sb->s_maxbytes is not equal to MAX_LFS_FILESIZE?
>>>
>> Patches to fix that are in the -mm kernel already (and in
>> Fedora Core 6 latest update.)
> 
> Good to know, presumably these also fix the underlying UDF problems in the
> UDF filesystem code that caused it to be put there in the first pace ?
> 
> (Security CVE-2006-4145)

Yeah, the patches are by Jan Kara who put the original limitation
in there as a temporary band-aid.
