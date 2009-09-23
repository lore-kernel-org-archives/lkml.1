Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbZIWX2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbZIWX2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 19:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZIWX2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 19:28:32 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:61307 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbZIWX2c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=amU79HkgvPRkrKNoiZTxcOvy/DDD5iv2mv6BsoS8kuxdG3S9AQYLQ5IgxJneZsrjj5
         rrOO46CQWR73XefGdHC5Nz43ol7EtvJ3HV9oPb8cuH2QAoUOYMiG5VN0VadqdE8AtgVy
         iR695fDC06C6d2zYLzzbQbPfkD3jWTEYFJM3k=
MIME-Version: 1.0
In-Reply-To: <200909231723.31786.bjorn.helgaas@hp.com>
References: <200909161715.24376.bjorn.helgaas@hp.com>
	 <200909211520.56800.bjorn.helgaas@hp.com>
	 <4AB95F41.1070500@lwfinger.net>
	 <200909231723.31786.bjorn.helgaas@hp.com>
Date: Wed, 23 Sep 2009 16:28:35 -0700
Message-ID: <86802c440909231628t6b35aae4u706c0c35590bc0d3@mail.gmail.com>
Subject: Re: fixing "pci=use_crs"
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Gary Hade <garyhade@us.ibm.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 4:23 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

>
> P.S.  Yinghai, you posted some patches earlier dealing with "only one
> HT chain."  You apparently have some insight into what's going on here,
> but unfortunately, the changelogs mean absolutely nothing to me.  Can
> you give me any clues?

which commit?

normally we only need to have split root resource into several pieces
when we have two HT chains or other io chains...

YH
