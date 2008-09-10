Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbYIJUov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbYIJUov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 16:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYIJUoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 16:44:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:35534 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYIJUoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 16:44:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Rdt209rMIJaBVUVhSEAPoWjfBh5/S5MkUZYvYMziGvMzalDKc82QwouY2/OcBTtdg
	+RgyLGghGT+/Fc9bkSUsg==
Message-ID: <166fe7950809101344l7a5e2b7pfba8b2a7c03814a1@mail.gmail.com>
Date: Wed, 10 Sep 2008 13:44:23 -0700
From: "Ranjit Manomohan" <ranjitm@google.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/2] Traffic control cgroups subsystem
Cc: kaber@trash.net, akpm@linux-foundation.org, lizf@cn.fujitsu.com,
       menage@google.com, tgraf@suug.ch, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20080910.132251.73509521.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0809101026190.7050@ranjit.corp.google.com>
	 <20080910.132251.73509521.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 1:22 PM, David Miller <davem@davemloft.net> wrote:
>
> I definitely prefer Thomas Graf's work, this stuff is very ugly
> and way overengineered.
>

Could you be more specific? Thomas' work is almost identical to this
(except that he does not store the cgroup id into the socket which is
a trivial change which has downsides which I have pointed out).

Additionally this approach has only minor modifications to the core
networking stack. What portions do you consider ugly and over
engineered and what alternative implementations would you prefer?
Please see the follow up I have sent to Thomas' proposal about why we
need this design approach to handle the inbound case.

I'd be ok if you accepted either change since  we just want a standard
kernel mechanism to do this.

-Thanks,
Ranjit

> So no, I won't consider for net-next-2.6, sorry.
>
>
