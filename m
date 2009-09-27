Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbZI0ODo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbZI0ODo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 10:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZI0ODn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 10:03:43 -0400
Received: from fifo99.com ([67.223.236.141]:48576 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbZI0ODn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 10:03:43 -0400
Subject: Re: [PATCH] WARN_ONCE(): use bool for boolean flag
From: Daniel Walker <dwalker@fifo99.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>
In-Reply-To: <1254059590-31690-1-git-send-email-cesarb@cesarb.net>
References: <1254059590-31690-1-git-send-email-cesarb@cesarb.net>
Content-Type: text/plain
Date: Sun, 27 Sep 2009 07:03:09 -0700
Message-Id: <1254060189.20648.462.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-27 at 10:53 -0300, Cesar Eduardo Barros wrote:
>  #define
> WARN_ON_ONCE(condition)        ({                              \
> -       static int __warned;                                    \
> +       static bool __warned;                                   \
>         int __ret_warn_once = !!(condition);                    \

Could __ret_warn_once be bool also ? It looks like just another
conditional variable..

Daniel

