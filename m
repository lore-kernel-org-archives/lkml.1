Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbZATLqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbZATLqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 06:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758204AbZATLqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 06:46:05 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:48049 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbZATLqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 06:46:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Dkmk4bTMwsBFUq9k0678cfCPZNLzKSwFZzGG+73BNXAF4bLJ9iM8wm5lbXS8JtAnO7
         APTpAG+W3/4G9ZdT4HvwVbfUAQE5aZOoU3JiMQIs5vlpdIjhjbJxUMfjo6R6N/2ryY3+
         K8nX5k38UbpBHL2t7jtGCODXzJIDSEOpBDBgY=
Message-ID: <4975B9C4.7030401@gmail.com>
Date: Tue, 20 Jan 2009 12:47:16 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>,
       xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net> <20090120004611.GA6445@disturbed> <20090120112910.GA6831@infradead.org>
In-Reply-To: <20090120112910.GA6831@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig pisze:
> On Tue, Jan 20, 2009 at 11:46:11AM +1100, Dave Chinner wrote:
>> On Mon, Jan 19, 2009 at 12:44:48PM -0600, Eric Sandeen wrote:
>>> Jacek Luczak wrote:
>>>> Hi All,
>>>>
>>>> I've stepped into XFS issue/bug. Yesterday I've compiled 2.6.29-rc2 and no
>>>> didn't found errors. Today I've booted my notebook and XFS bug have occurred.
>>>> System reboot didn't helped, same error appeared.
>>>>
>>>> Some info:
>>>> [1] config: http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2.config
>>>> [2] kernel logs:
>>>> http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2_XFS-bug.log
>>>> [3] most interesting part of log below.
>>> so this happens every mount?  Reproducible is good.  How large is the
>>> filesystem (too large to extract elsewhere for analysis...?) (plus I
>>> suppose it'll be hard to get to it when you can't even boot....)
>> XFS folks, I suspect the common link between all the reports of this
>> bug is that they are on 32-bit kernels. I can't reproduce this on
>> a 64 bit kernel, and I'm trying to get a 32-bit UML built right now
>> to test this theory.
> 
> I'm doing about half of my testing on 32 bit x86, and I couldn't
> reproduce the detailed receipe  in the kernel.org bugzilla yet.
> 
> Just curious:  do you have CONFIG_LBD set?
> 
Hi Christoph,

the answer is:
$ grep LBD .config
# CONFIG_LBD is not set

-Jacek
