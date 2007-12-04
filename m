Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbXLDQo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbXLDQo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXLDQou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:44:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbXLDQot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:44:49 -0500
Date: Tue, 4 Dec 2007 11:43:58 -0500
From: Alan Cox <alan@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, alan@redhat.com,
       chrisw@redhat.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, solar@openwall.com,
       wtarreau@hera.kernel.org
Subject: Re: [PATCH] VM/Security: add security hook to do_brk
Message-ID: <20071204164358.GA18050@devserv.devel.redhat.com>
References: <1196784415.2912.164.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196784415.2912.164.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 11:06:55AM -0500, Eric Paris wrote:
> Given a specifically crafted binary do_brk() can be used to get low
> pages available in userspace virtually memory and can thus be used to
> circumvent the mmap_min_addr low memory protection.  Add security checks
> in do_brk().
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

ACK
