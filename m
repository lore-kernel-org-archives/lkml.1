Return-Path: <linux-kernel-owner+w=401wt.eu-S1761361AbXHXQQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761361AbXHXQQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbXHXQQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:16:06 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:44412 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbXHXQQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:16:05 -0400
X-Greylist: delayed 3964 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2007 12:16:05 EDT
Message-ID: <46CEF49A.2050105@emc.com>
Date: Fri, 24 Aug 2007 11:09:14 -0400
From: Ric Wheeler <ric@emc.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: John Stoffel <john@stoffel.org>, Peter Staubach <staubach@redhat.com>,
       Robin Lee Powell <rlpowell@digitalkingdom.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
References: <20070820225415.GL3956@digitalkingdom.org> <18123.5699.405125.137517@stoffel.org> <46CB1A78.7040102@redhat.com> <18123.13314.43009.263383@stoffel.org> <20070821192556.GB27995@fieldses.org>
In-Reply-To: <20070821192556.GB27995@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.7.6.21134
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, __C230066_P2 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Tue, Aug 21, 2007 at 02:50:42PM -0400, John Stoffel wrote:
>   
>> Not in my experience.  We use NetApps as our backing NFS servers, so
>> maybe my experience isn't totally relevant.  But with a mix of Linux
>> and Solaris clients, we've never had problems with soft,intr on our
>> NFS clients.
>>
>> We also don't see file corruption, mysterious executables failing to
>> run, etc.  
>>
>> Now maybe those issues are raised when you have a Linux NFS server
>> with Solaris clients.  But in my book, reliable NFS servers are key,
>> and if they are reliable, 'soft,intr' works just fine.
>>     
>
> The NFS server alone can't prevent the problems Peter Staubach refers
> to.  Their frequency also depends on the network and the way you're
> using the filesystem.  (A sufficiently paranoid application accessing
> the filesystem could function correctly despite the problems caused by
> soft mounts, but the degree of paranoia required probably isn't common.)
>   
Would it be sufficient to insure that that application always issues an 
fsync() before closing any recently written/updated file? Is there some 
other subtle paranoid techniques that should be used?

ric

