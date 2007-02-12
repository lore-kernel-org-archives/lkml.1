Return-Path: <linux-kernel-owner+w=401wt.eu-S964833AbXBLJwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833AbXBLJwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964841AbXBLJwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:52:09 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:16621 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964833AbXBLJwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:52:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oBQP0oxw4RT71SqnrUwir2c+jwyX7XcB5gtB8JEKLPhSq5v9my19N/05WE/jVGbun9hkNrShTysQJRqaaoK0qAQJSr2fo2RO6bhX8Kwtwx0qIipqWY0WIaO0nUVq2gFkw+kvHA8yFtP5MjOnXPLrtKe/hftH6M2KHSqyF0eTqO8=
Message-ID: <b6a2187b0702120152s1279b931x813413a4234d8dec@mail.gmail.com>
Date: Mon, 12 Feb 2007 17:52:06 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [QUESTION] file access time in millisecond?
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <p73bqjzhhp7.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0702112327t7294c221w460b3bd0f77d0e@mail.gmail.com>
	 <p73bqjzhhp7.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 Feb 2007 10:02:28 +0100, Andi Kleen <ak@suse.de> wrote:

> > stat() returns time in seconds,
>
> Not correct (at least for glibc stat). It supports nanoseconds these days,
> although not all file systems (including ext3) do yet.

I'm using gcc-3.4.5, and glibc-2.3.6. Don't think 2.3.6 stat() support
that ... at least the man page doesn't indicate so.

Does that mean it's time to upgrade to glibc-2.5? or what's version
should I use?

I'm worry it'll break oracle, cups, mozilla or something else.

Thanks,
Jeff.
