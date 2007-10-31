Return-Path: <linux-kernel-owner+w=401wt.eu-S1759837AbXJaV4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbXJaV4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbXJaVz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:55:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48890 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbXJaVz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:55:57 -0400
Date: Wed, 31 Oct 2007 22:57:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       per.liden@ericsson.com, jon.maloy@ericsson.com,
       allan.stephens@windriver.com
Subject: Re: [PATCH] Fix make headers_check for tipc
Message-ID: <20071031215734.GB28556@uranus.ravnborg.org>
References: <20071031212932.GA4933@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031212932.GA4933@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 05:29:32PM -0400, Dave Jones wrote:
> make headers_check currently fails in mainline with..
> 
> include/linux/tipc_config.h requires linux/string.h, which does not exist in exported headers
> 
> There's no reason to even include this in this header as far as I can tell.
The inline functions uses memcpy().

But if you just pull a fresh tree you will notice that it is fixed.
Davem did so in a rather elegant way.

	Sam
