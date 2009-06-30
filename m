Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbZF3RVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbZF3RVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 13:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZF3RU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 13:20:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46731 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZF3RU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 13:20:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4A4A16260200007800008340@vpn.id2.novell.com>
References: <4A4A16260200007800008340@vpn.id2.novell.com>
To: "Jan Beulich" <JBeulich@novell.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix hpet_(un)register_irq_handler() again for emulation
Date: Tue, 30 Jun 2009 18:20:59 +0100
Message-ID: <10766.1246382459@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich <JBeulich@novell.com> wrote:

> For hpet_unregister_irq_handler(), an expression the effective of is
> "void" ought to be used instead.

Inline functions should probably be used instead.

David
