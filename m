Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbYFERdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbYFERdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 13:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbYFERdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 13:33:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:45237 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757986AbYFERdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 13:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D/+6WQCPtgn5ZCo6LkidjQ6HS4HJBNLrtohZ7mOk3WiWsB91tB7/SnEgoLyt9DZQBl
         JGP/NK6vtmni+a8MuV0fiHM1vQkVglvBc9IkxwqvJzYsxCMZNZwM4S0G6To1jnUJpRc4
         iNubzjZ4KWL96JCYqIpYv/k0Yl9YZnS6RDWVI=
Message-ID: <86802c440806051033k7a0a5306qc22555d3ebd48757@mail.gmail.com>
Date: Thu, 5 Jun 2008 10:33:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: RFC [PATCH] x86: make generic arch support NUMAQ
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080605123933.GA22737@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806050309.11197.yhlu.kernel@gmail.com>
	 <20080605110002.GB17961@uranus.ravnborg.org>
	 <20080605123933.GA22737@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 5:39 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Sam Ravnborg <sam@ravnborg.org> wrote:
>
>> > +#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
>>
>> I counted several places where you test for the above. Introducing a
>> CONFIG_X86_NUMAQ_OR_GENERIC would simplify stuff.
>
> Yinghai, please get rid of the NUMAQ build option altogether and
> eliminate the subarch.
>
> We should keep a compatibility CONFIG_X86_NUMAQ that selects
> X86_GENERICARCH, so that 'make oldconfig' on a NUMAQ config does the
> right thing - but it's not a subarch anymore nor anything
> user-configurable.

how about the Summit, and ES7000? You still have the two entries for them.

Anyway, will remove entry in the list and make CONFIG_X86_NUMAQ select
X86_GENERICARCH

and make the those ifdef only use X86_GENERICARCH...

YH
