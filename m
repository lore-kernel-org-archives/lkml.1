Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbYHKSIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbYHKSIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYHKSIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:08:40 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:31960 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYHKSIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:08:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vbmWC4+lvSQlgAzA2gyqQyMJ537tXRUp5NHt1RXcSN8ud/2DbAaIByn5lAcn2dnO5a
         KGwI39xOK5GX5Dn/VbenAZhpagTKy1ZxpT8ZZzdZhZBBAwow86Ebp5m+OiNqh+HeprJF
         iPUQucBdRIPu0WC7U+986nDxM6HCXwGihyVns=
Message-ID: <86802c440808111108h3a14d98dwae52d1b1b8c5c52f@mail.gmail.com>
Date: Mon, 11 Aug 2008 11:08:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- RCU problem
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, netdev <netdev@vger.kernel.org>
In-Reply-To: <49829.86808.qm@web82105.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49829.86808.qm@web82105.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 11:01 AM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
> Thanks for the reply.  Let me address these out of order (cutting
> your post):
>
>> David, it would be nice to check whether tip/master still locks up for
>> you:
>>
>>     http://people.redhat.com/mingo/tip.git/README
>>
>> just to make sure no pending fix resolves your issue. (the bug is
>> probably still present, but might be worth checking nevertheless.)
>
> Just to recap (not sure if you saw the earlier posts in the thread, going
> back to Monday a week ago):
>
> - kernel 2.6.25 worked for me without error

does hpet work at 2.6.25? or it is not enabled by default for the
famous chipset?

YH
