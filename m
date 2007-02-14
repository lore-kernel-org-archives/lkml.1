Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbXBNUmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbXBNUmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXBNUmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:42:52 -0500
Received: from gw.goop.org ([64.81.55.164]:36404 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbXBNUmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:42:52 -0500
Message-ID: <45D37445.50306@goop.org>
Date: Wed, 14 Feb 2007 12:42:45 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 16/21] Xen-paravirt: Add code into head.S to handle being
 booted by Xen
References: <20070213221729.772002682@goop.org>	<20070213221830.707197267@goop.org> <m1sld8pjhy.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1sld8pjhy.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
> There need to be alignment directives for the page aligned chunks.
>   

OK.

> Placing the page aligned chunks in a special section is nice in that
> it ensures the linker packs everything tightly but should be
> completely unnecessary if the alignment is correct.
>   
Yes, I made the extra section to get better packing.

    J
