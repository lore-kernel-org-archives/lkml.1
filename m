Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYH2IlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYH2IlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbYH2IlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:41:04 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:25561 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbYH2IlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:41:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=rYnF+h50eYQJPuc8fP7YhV6JUn6QKWKqCCIojFnLt/u5SXgV6aN1dByGRWyKw46aNB
         WuaefKc135gdD00EHiTr7UJqTB4++NvEZopqoIDfI7Ppj3j5pB7h5w0+o3LBvCBeYdM8
         f/ubSgPReZE8DWrrXlMHwu2dkK9BwdQ7h2TOw=
Message-ID: <48B7B618.7050409@tuffmail.co.uk>
Date: Fri, 29 Aug 2008 09:40:56 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: LKML <linux-kernel@vger.kernel.org>, kovlensky@interia.pl
Subject: Re: mounting windows shares with path exactly like on windows
References: <48B7B0F3.1050601@wpkg.org>
In-Reply-To: <48B7B0F3.1050601@wpkg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Chmielewski wrote:
>> In short - I've got bunch of applications running both on windows and
>> linux and these applications \
>> exchange links to files mounted on both sides. The problem is that
>> these paths are different, i.e. like \
>> D:/dir/file on windows and /mountpoint/dir/file on Linux. What I need
>> is unifying them. So my idea is to \
>> have path translator on anything on kernel level, which will make
>> Linux open call to D:/dir/file on Linux \
>> work and open /mountpoint/dir/file. Was anything close to that ever
>> incorporated in kernel?
>
> What's wrong with just:
>
> # mkdir -p /D:/dir
> # mount.cifs ...
> # touch /D:/dir/file
>
> ?
>
> Or, use symlinks from /D:/dir to /mountpoint/dir/
That only works from the root directory though.  In unix, "C:/" is a
relative path.

Alan

