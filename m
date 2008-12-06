Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbYLFBQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbYLFBQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 20:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYLFBQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 20:16:37 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:37860 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYLFBQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 20:16:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TFaKc7PQPOjzKPZSQ3bxKHY6uIjFmg73bPXck3fs1uudtKLr2fm4RknSIYUisuJt/8
         NoaAd4T16P/mudzoyCbNLH7jyheVdiT5/wHcJYBCTQ3qpaasWqlQQYAxFhRIdC3PdE6u
         V/6u7vuzYqrJ7cKGQFnorDvkFmP8Dun+fT1vc=
Message-ID: <2375c9f90812051716w6974a18asd4c34cb47bd64aa4@mail.gmail.com>
Date: Sat, 6 Dec 2008 01:16:34 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH][UML] Boot broken due to buffer overrun
Cc: balbir@linux.vnet.ibm.com, penberg@cs.helsinki.fi, jdike@addtoit.com,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, stable@kernel.org
In-Reply-To: <20081202121707.e1623f89.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081129100830.GA24128@balbir.in.ibm.com>
	 <84144f020811290221g947f836n4fe3435676425ee@mail.gmail.com>
	 <20081129122039.GA31635@balbir.in.ibm.com>
	 <20081202121707.e1623f89.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 8:17 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 29 Nov 2008 17:50:39 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>> * Pekka Enberg <penberg@cs.helsinki.fi> [2008-11-29 12:21:46]:
>>
>> > Hi Balbir,
>> >
>> > On Sat, Nov 29, 2008 at 12:08 PM, Balbir Singh
>> > <balbir@linux.vnet.ibm.com> wrote:
>> > > mconsole_init() passed 256 bytes as length in os_create_unix_socket, while
>> > > the sizeof UNIX_PATH_MAX is 108. This patch fixes that problem and avoids
>> > > a big overrun bug reported on UML bootup.
>> >
>> > Maybe mention that ->sun_path in struct sockaddr_un is UNIX_PATH_MAX
>> > long which causes the problem?
>> >
>>
>> Yes, the changelog can definitely add that to the changelog, I'll
>> resend the patch if Jeff asks for it.
>
> Jeff's been quiet lately - I'll merge this one.


Yes, indeed.

>
> I also tagged it for -stable, subject to Jeff's OK.  I'm wondering why
> this wasn't observed in earlier kernels?

Maybe because mconsole is not often used for uml? :)
