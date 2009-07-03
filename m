Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbZGCHkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbZGCHkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZGCHkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:40:32 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:31809 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbZGCHkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:40:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M921dwhshht7vow2+IHppa7oUFkDRPzO9/Zxmomv+aMYgkvEXRNvAWDTMnse7iC1X4
         d+6CulEiDcYTHmGeOM2DLgRs07SAKKkLUpIc8c4gDDtI9ZtyaOsQEmHX4SCGcfy+4lBL
         2w+cmBAQKEQoGo+rdD55vwu1vT0+GBAKkgBnM=
MIME-Version: 1.0
In-Reply-To: <20090703071504.GG5880@cr0.nay.redhat.com>
References: <20090702094620.GE6372@cr0.nay.redhat.com>
	 <20090702102138.GF6372@cr0.nay.redhat.com>
	 <412e6f7f0907021743m6ed8ae10uecd13c4fc4ec7cbb@mail.gmail.com>
	 <20090703015554.GB5880@cr0.nay.redhat.com>
	 <412e6f7f0907021910w64af0525h17afb518f0e18f97@mail.gmail.com>
	 <20090703030008.GD5880@cr0.nay.redhat.com>
	 <412e6f7f0907022108p7c533ed2wd16fceb0f282ed62@mail.gmail.com>
	 <20090703051917.GE5880@cr0.nay.redhat.com>
	 <412e6f7f0907022242r52ad981fyd51c2a55f41ab228@mail.gmail.com>
	 <20090703071504.GG5880@cr0.nay.redhat.com>
Date: Fri, 3 Jul 2009 15:40:34 +0800
Message-ID: <412e6f7f0907030040v6133badat7058186a01d78f44@mail.gmail.com>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
From: Changli Gao <xiaosuo@gmail.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 3:15 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>
> If saving one fd really helps here, probably you want to
> save more, you will need a syscall like:
>
>  int splice_without_new_fd(int infd, int outfd);
Do you know sendfile()? Its current implementation is buggy, and will
be blocked on outfd. Anyway, the above code is just a use case, there
are other cases sendfile can't cover.

>
> But splice(2) is designed to be as it is. You need to increase
> your fd limit, instead of saving one by pipe().
>
I don't agree with you. We should save resource as much as we can, and
not work around it.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
