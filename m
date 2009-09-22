Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbZIVOFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbZIVOFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbZIVOFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:05:07 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:42428 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbZIVOFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RW3VjJsH4x6yiSf4mEGq+YEniPyIXeBqVmmXqEqWsV7T4r10iSMkNvxnAgohAU/w1a
         /Z5EhWzZ0oVly5ro5+N/bj42RagjyeymHLkbll00ONIY9wZFojOpC0iYzus7nVDdapjl
         mekU8vimqo3AJm8YJWXQq4zwiZLHAO1Nkz0dk=
MIME-Version: 1.0
In-Reply-To: <CCABB2CC-E9F7-4153-8B60-85619DE71A13@kernel.crashing.org>
References: <Pine.LNX.4.64.0909192149250.27171@ask.diku.dk>
	 <20090921160532.GC3868@hack>
	 <CCABB2CC-E9F7-4153-8B60-85619DE71A13@kernel.crashing.org>
Date: Tue, 22 Sep 2009 22:05:08 +0800
Message-ID: <2375c9f90909220705m6767ace3y5b431d1aa26ef945@mail.gmail.com>
Subject: Re: [PATCH 5/5] arch/um: remove duplicate structure field 
	initialization
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Julia Lawall <julia@diku.dk>, jdike@addtoit.com,
       user-mode-linux-user@lists.sourceforge.net,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 12:26 AM, Segher Boessenkool
<segher@kernel.crashing.org> wrote:
>> "
>> The initialization shall occur in initializer list order, each
>> initializer provided for a particular subobject overriding any
>> previously listed initializer for the same subobject [...]
>> "
>>
>> I am wondering why gcc doesn't (can't?) complain about this?
>
> Does -Woverride-init (included in -Wextra / -W) not work?  If so, please
> file a bug report.

Hmm, right, it works, but it seems that Linux kernel doesn't use it.
Maybe we should add it? :-/
