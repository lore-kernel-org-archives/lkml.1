Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab0BQQjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:39:40 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:42431 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab0BQQji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:39:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cGco0WHkw3cP7aVUjdLUizntYyL3LaaMT/xUuCJLRenSnWJxCKxq5bIcT7/S/JtSiP
         g6gAYq9mQsCGiynrcg4X7hEZ8zO2sggcsfRQE46GY8iecytqYh0xiNsFpk0OstbtL55N
         NCLJdAG5dnLGYadeSeHnqMg7QvshvD5VaQJ9k=
Subject: Re: [net-next PATCH v4 3/3] net: reserve ports for applications
 using fixed port numbers
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <amwang@redhat.com>
Cc: Octavian Purdila <opurdila@ixiacom.com>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>
In-Reply-To: <4B7C159A.3060603@redhat.com>
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com>
	 <1266271241-6293-4-git-send-email-opurdila@ixiacom.com>
	 <4B7A6740.1000701@redhat.com> <201002161306.29708.opurdila@ixiacom.com>
	 <4B7A9852.5020105@redhat.com> <1266326425.3045.53.camel@edumazet-laptop>
	 <4B7C159A.3060603@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Feb 2010 17:39:28 +0100
Message-ID: <1266424768.3075.61.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 18 février 2010 à 00:13 +0800, Cong Wang a écrit :

> I don't think so, if you want to avoid race condition, you just need to
> write the reserved ports before any networking application starts, IOW,
> as early as possible during boot.
> 

Sure, but I was thinking retrieving the list of reserved port by a
database query, using network :)

Anyway, I just feel your argument is not applicable.

Our kernel is capable of doing an intersection for us, we dont need
to forbid user to mark a port as 'reserved' if this port is already
blacklisted by another mechanism (for example, if this port is already
in use)



