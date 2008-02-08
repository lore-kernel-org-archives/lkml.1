Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYBHFZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYBHFZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 00:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYBHFZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 00:25:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:55905 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbYBHFZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 00:25:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:bcc:subject:reply-to:in-reply-to:message-id;
        b=ODCDDU7FIbdEK4ShmnUmp0aMclpI5ub+Pkb455umoGSXW2cYeQx0GeiSF5pHTtrNRbJt/uxR7HzKnYNLOtmNwtfKQVRyeK0HIFwEtmfbg0F70luWcp6EHMLnrtx8J4CqNT0SWnxvtZtTkG/o/mKE7vRn5t03/4BxMUYRNu5ekFE=
Date: Thu,  7 Feb 2008 21:32:30 -0800
From: Glenn Griffin <ggriffin.kernel@gmail.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Glenn Griffin <ggriffin.kernel@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add IPv6 support to TCP SYN cookies
In-Reply-To: <47AAD203.4030706@cosmosbay.com>
Message-ID: <47abe7b1.20588c0a.7013.75b7@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Or maybe use percpu storage for that...

That seems like a good approach.  I'll incorporate it into my v6 patch,
and send out an update.  Thanks.

> I am not sure if cookie_hash() is always called with preemption disabled.
> (If not, we have to use get_cpu_var()/put_cpu_var())

cookie_hash is always called within NET_RX_SOFTIRQ context so I believe
preemption will always be disabled by __do_softirq().  So there
shouldn't be a need to use get_cpu_var/put_cpu_var, somebody correct me
if I'm wrong.

--Glenn

