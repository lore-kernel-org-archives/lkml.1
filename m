Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbXGIUyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbXGIUyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbXGIUy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:54:27 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:40264 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbXGIUy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o2PxM+UXHZVXbGF+DI6nh3HP+Nt60A6QEpTYvAre/uGhSoRJ8ua2EI6+jviZ+BOiZvDL26mqXMprS6/1mTVJaGDzFdPnFwjxp6xYKg5iU1du54FhU059fdTewcjpYzWuSpImSaMK4XbJzSy/0Shmqv/xBbqM9/PiD6YmHPJ8d+Y=
Message-ID: <ec870ced0707091354y770e5a26y4493e2c935cb088e@mail.gmail.com>
Date: Mon, 9 Jul 2007 22:54:25 +0200
From: "Pawel Dziepak" <hryssta@gmail.com>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Subject: Re: clocksource tsc unstable
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4692981E.20303@mandic.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46924CEB.7080108@mandic.com.br> <46925970.8080602@redhat.com>
	 <4692981E.20303@mandic.com.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As far as i know Pentium M processors have dynamically changed clock
speed (ofc to save power). That's why kernel notice that TSC is
unstable (it is indeed). On my Athlon 64 I have similar situation,
because CPU frequency is dynamically changed.
I don't think that there is an easy way to fix it (it is not even a
bug), time-stamp counter is not perfect...

Regards,
Pawel
