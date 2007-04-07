Return-Path: <linux-kernel-owner+w=401wt.eu-S933572AbXDGAOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbXDGAOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 20:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933575AbXDGAOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 20:14:16 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39856 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933572AbXDGAOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 20:14:15 -0400
Date: Fri, 6 Apr 2007 17:14:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] Char: cyclades, remove volatiles
Message-Id: <20070406171406.317ea28a.akpm@linux-foundation.org>
In-Reply-To: <25307199761334218148@karneval.cz>
References: <16309194841640222796@karneval.cz>
	<25307199761334218148@karneval.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Apr 2007 23:45:38 +0200 (CEST) Jiri Slaby <jirislaby@gmail.com> wrote:

> cyclades, remove volatiles

The other changes seem uncontroversial, but this one has the potential
to change runtime behaviour.  And cyclades.c is a driver which some people
actually use ;)

Have these changes been runtime-tested?
