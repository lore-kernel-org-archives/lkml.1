Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab0CJKLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:11:44 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:23192 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab0CJKLj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:11:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VKcSLXaqp6X9CkQ15k1hY5QAJFBlwZIp2FmSAtmwqWS4pXm2wno/9+Pv1YZcsnqysU
         qKXZIn2XFnr4Lkicj39M8+4P5drmfG8JQVMsmp3Rbi3HCVfjDBirIthU5EN6MlzuNBEK
         zhZscM3/df7ze5Dqj6g3gtPzj7TvRBxMI/Pqo=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1003100205170.17698@chino.kir.corp.google.com>
References: <4B90CBE5.9090102@viscovery.net>
	 <1267780845-10547-1-git-send-email-jslaby@suse.cz>
	 <m3pr3jkq26.fsf@localhost.localdomain> <4B9120F2.2020000@gmail.com>
	 <alpine.DEB.2.00.1003100205170.17698@chino.kir.corp.google.com>
Date: Wed, 10 Mar 2010 18:11:38 +0800
Message-ID: <2375c9f91003100211vbe66a49g1bec37b2dcf609c2@mail.gmail.com>
Subject: Re: [PATCH 1/1] gitignore: do not ignore include/linux/
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Jakub Narebski <jnareb@gmail.com>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       git@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Sixt <j.sixt@viscovery.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 6:07 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 5 Mar 2010, Jiri Slaby wrote:
>
>> On 03/05/2010 11:43 AM, Jakub Narebski wrote:
>> >> +!/.gitignore
>> >> +!/.mailmap
>> >
>> > Actually you want to *not ignore* .gitignore and .mailmap (and
>> > .gitattributes which is missing here) anywhere, not only as top-level
>> > file.  So .gitignore and .mailmap should not be prepended with slash.
>>
>> <and moved out of the 'Top-level generic files' section then>
>>
>
> Please either revert 3b2a8c8f3c65 or merge the fixed up patch for
> 2.6.34-rc2, otherwise include/linux will continue to be ignored by git
> just like it is for 2.6.34-rc1.

Why not apply the patch from Jiri? Since this problem is introduced
by new version of git, not that commit.
