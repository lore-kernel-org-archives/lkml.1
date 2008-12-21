Return-Path: <linux-kernel-owner+w=401wt.eu-S1751901AbYLUULj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbYLUULj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 15:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYLUULb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 15:11:31 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:54528 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYLUULa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 15:11:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=vHobmGzhIRMYEBBERdvRQS/Tteh/WgPYjjMlQtuSMB9lHq4megg4uekVsFWzz4Cmks
         NdiO1x4eOGUz++H6CNiAm1QMnipjJC8LJ9UCrPLFsjDvGe73cCrtMUU+y8wva02BwT79
         t5ZZnuEzK0qddilIPWcxigz37Dbdhu77aLRs8=
Message-ID: <494EA2ED.6080901@gmail.com>
Date: Sun, 21 Dec 2008 21:11:25 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: pl ice <telent997@gmail.com>
CC: Zwane Mwaikambo <zwane@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: when interrupt came, the kernel save pt_regs->eip always the
 same?
References: <41d311580812130732u58f480ecgc21cb6f16365d45a@mail.gmail.com>	 <41d311580812130740k6e0c139kacb5bad33b5b8fd4@mail.gmail.com>	 <41d311580812130748o262fdb31se647e840977d90a9@mail.gmail.com>	 <alpine.DEB.2.00.0812130854380.28394@montezuma.windriver.com> <41d311580812131859k41f1693lac4872773befe15d@mail.gmail.com>
In-Reply-To: <41d311580812131859k41f1693lac4872773befe15d@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the repost, following the thread now.
BTW. do not top-post.

On 12/14/2008 03:59 AM, pl ice wrote:
> And the prototype about irq_handler changed, the 3th parameter "struct
> pt_regs" removed,How do i get the struct pt_regs in my interrupt
> handler because kernel doesn't deliver to me?

get_irq_regs() should do that.
