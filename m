Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab0CHPw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:52:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab0CHPwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:52:25 -0500
Date: Mon, 8 Mar 2010 10:51:33 -0500
From: Jason Baron <jbaron@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Banks <gnb@melbourne.sgi.com>,
       =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] dynamic_debug: small clean up in ddebug_proc_write()
Message-ID: <20100308155132.GA2734@redhat.com>
References: <20100306105934.GA4958@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100306105934.GA4958@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 01:59:34PM +0300, Dan Carpenter wrote:
> This the doesn't change behavior at all.  In the original code, if nwords
> was zero then ddebug_parse_query() would return -EINVAL, now we just do 
> it earlier.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 

I guess it makes the code a little more readable.

Acked-by: Jason Baron <jbaron@redhat.com>
