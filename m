Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbXH1Qut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbXH1Qut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbXH1Qum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:50:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:60516 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752921AbXH1Qum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:50:42 -0400
X-Authenticated: #12383568
X-Provags-ID: V01U2FsdGVkX18DdKJfCikDYJeLVHITKBAiqePVmBVyeUYTkd/Dnt
	XLZ8M53j2hv4nk
From: Clemens Kolbitsch <clemens.kol@gmx.at>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: user-mode stack size & location
Date: Tue, 28 Aug 2007 18:50:31 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200708281825.01688.clemens.kol@gmx.at> <20070828094548.34186c0c@laptopd505.fenrus.org>
In-Reply-To: <20070828094548.34186c0c@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708281850.32975.clemens.kol@gmx.at>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> hi,
>
> if you look where arch_align_stack() gets called.. that's where you
> want to look. arch_align_stack() gets invoked in code that selects
> userspace stack pointers....
>
> Greetings,
>    Arjan van de Ven

thanks a lot!!
