Return-Path: <linux-kernel-owner+w=401wt.eu-S1758535AbYJHCup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbYJHCup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 22:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbYJHCug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 22:50:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:58374 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbYJHCuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 22:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=muK6PfWlOvErD6unLt5DljT3R6sbmUKzMSDCybOKLohlJrVXv8Vto+0jsd3MwVV03Q
         jsnISZrkHWrIGprSo6VXe8P2PqLo80Imz53noYTsUds7j5qyuJoA/RdqrbI9rUdkSkWP
         ZKoreZAhVhqX6DdNN7Z2Wpliiyy9zJuFmqyWk=
Message-ID: <cfd18e0f0810071950y5ce93997g62781d25c7383e1d@mail.gmail.com>
Date: Wed, 8 Oct 2008 04:50:34 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [RFC patch 0/3] signals: add rt_tgsigqueueinfo syscall
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Oleg Nesterov" <oleg@tv-sign.ru>
In-Reply-To: <20081007202135.15982154271@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080930194445.978351700@linutronix.de>
	 <cfd18e0f0810070649l391978f9v345a5591728bbf41@mail.gmail.com>
	 <20081007202135.15982154271@magilla.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2008 at 10:21 PM, Roland McGrath <roland@redhat.com> wrote:
> You need .sa_flags = SA_SIGINFO.

D'oh!  Overlooking the obvious!  Thanks Roland.
