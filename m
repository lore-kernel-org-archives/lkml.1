Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbYBYGVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbYBYGVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYBYGVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:21:10 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:55468 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbYBYGVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:21:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f2KTF5I1UJwUqOaQ43arlrYMVDFAtUIW0nJMYSouFpU8VOMa6lCX2or5NU/leT2Bgmka/tYpI70hWh2WJ9u9ERjoDjzcaz8obprQ/tNEfYWP96R+KwMvopQqikFs3+q2Cxk34YezVakibSbuLNIaC8xq+ERKrJGF0L75zw94KoE=
Message-ID: <9810cff90802242221x2f16dc79k634cecf2c1cee41e@mail.gmail.com>
Date: Sun, 24 Feb 2008 22:21:07 -0800
From: "Bill Huey (hui)" <bill.huey@gmail.com>
To: gregory.haskins@gmail.com
Subject: Re: [PATCH [RT] 11/14] optimize the !printk fastpath through the lock acquisition
Cc: "Pavel Machek" <pavel@ucw.cz>, "Gregory Haskins" <ghaskins@novell.com>,
       mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, ak@suse.de, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
In-Reply-To: <47C2500E.9080407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
	 <20080221152722.4804.77478.stgit@novell1.haskins.net>
	 <20080222191837.GE6060@ucw.cz> <47BF4AC5.7070507@gmail.com>
	 <9810cff90802221643g7d993af4k33f29fb4a4663407@mail.gmail.com>
	 <47C2500E.9080407@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[repost with all folks CCed]

On Sun, Feb 24, 2008 at 9:20 PM, Gregory Haskins
<gregory.haskins.ml@gmail.com> wrote:
>  Are you saying that the modified logic that I introduced is broken?  Or
>  that the original use of the might_sleep() annotation inside this
>  function is broken?

It's probably safe to use, but it's not what its original purpose was
and you should use another function/macro. This is an annotation issue
and your use of it is inconsistent with how it's used in voluntary
preempt. I mentioned it before in a previous post. Folks will correct
me if I'm wrong but you should use another macro or function.

bill
