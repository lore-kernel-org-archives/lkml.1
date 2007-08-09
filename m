Return-Path: <linux-kernel-owner+w=401wt.eu-S938950AbXHIFyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938950AbXHIFyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765880AbXHIFx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:53:56 -0400
Received: from gw.goop.org ([64.81.55.164]:39756 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbXHIFx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:53:56 -0400
Message-ID: <46BAAB8C.9080709@goop.org>
Date: Wed, 08 Aug 2007 22:52:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 7/25] [PATCH] interrupt related native paravirt functions.
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com> <11865467812610-git-send-email-gcosta@redhat.com>
In-Reply-To: <11865467812610-git-send-email-gcosta@redhat.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> The interrupt initialization routine becomes native_init_IRQ and will
> be overriden later in case paravirt is on.
>
> The interrupt vector is made global, so paravirt guests can reference
> it in their initializations.

Why?  And if so, wouldn't it be better to add an accessor function instead?

    J
