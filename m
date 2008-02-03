Return-Path: <linux-kernel-owner+w=401wt.eu-S934234AbYBCH22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934234AbYBCH22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 02:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYBCH2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 02:28:19 -0500
Received: from relay1.sgi.com ([192.48.171.29]:56378 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753430AbYBCH2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 02:28:18 -0500
Date: Sun, 3 Feb 2008 01:28:15 -0600
From: Paul Jackson <pj@sgi.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: sparse warnings in cpuset.c
Message-Id: <20080203012815.05a50b13.pj@sgi.com>
In-Reply-To: <1202019619.1844.52.camel@brick>
References: <1202019619.1844.52.camel@brick>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey wrote:
> No need to redeclare p, we have finished with it at this point,
> so reuse it in the for loop.

Good catch, however I disagree with the fix.  It makes the code more
brittle.

It's not a good idea to reuse a variable for some other purpose just
because you "know" the original use is dead. Things don't necessarily
stay dead; code moves around.

Could you prepare a revised version of this patch, that instead of
dropping that declaration of 'p', rather renames it to 'q' ?

Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
