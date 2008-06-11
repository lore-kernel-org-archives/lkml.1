Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbYFKCvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbYFKCvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 22:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbYFKCvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 22:51:31 -0400
Received: from saeurebad.de ([85.214.36.134]:46125 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbYFKCvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 22:51:31 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ralph Campbell <ralph.campbell@qlogic.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: bug in jiffy time comparison macros
References: <1213144181.5452.26.camel@chromite.mv.qlogic.com>
Date: Wed, 11 Jun 2008 04:51:26 +0200
In-Reply-To: <1213144181.5452.26.camel@chromite.mv.qlogic.com> (Ralph
	Campbell's message of "Tue, 10 Jun 2008 17:29:41 -0700")
Message-ID: <87hcc0it01.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ralph Campbell <ralph.campbell@qlogic.com> writes:

> It may just be me :-) but this looks like a bug:
> In the current include/linux/jiffies.h:
>
> #define time_before(a,b)        time_after(b,a)
>
> Shouldn't this be:
>
> #define time_before(a,b)        time_after_eq(b,a)

Then it would be time_before_eq()..?

If a is before b, b must be after a.  If they might be equal, than from
both points of view.

	Hannes
