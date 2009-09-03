Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZICGXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZICGXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 02:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbZICGXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 02:23:30 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:36412 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbZICGX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 02:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ULClW61bpS1AC00KUlzdR3NMrBhEy1h2S4LBnyneflEm2De3oQZ4+c3sa6Wd5tuJVw
         SBFTUo/JbkjZEzXOj9mDFVCl1qUCF876+zrXWURghPj4xdXRbrDpMyEoC0djI2+GE/Ae
         0lysBkBk7UfePrI5jLBLHgKp1NWi3dafE6/lw=
MIME-Version: 1.0
In-Reply-To: <43e72e890909021729q7c40f907v7a81eaf5c8b73a61@mail.gmail.com>
References: <43e72e890909021729q7c40f907v7a81eaf5c8b73a61@mail.gmail.com>
Date: Thu, 3 Sep 2009 09:23:30 +0300
X-Google-Sender-Auth: 9868153a4d83f850
Message-ID: <84144f020909022323na828156v4eb9a8497cadaef8@mail.gmail.com>
Subject: Re: Exporting kmemleak.h to userspace
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 3:29 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> I was reviewing kmemleak code and noticed kmemleak.h went exported to
> userspace under include/linux/kmemleak.h. Do we expect userspace to
> use this stuff somehow? All relevant kmemleak structs are kept
> private, I'm curious what userspace apps would use this.

AFAICT, nobody. Catalin, why is the header exported?
