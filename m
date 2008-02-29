Return-Path: <linux-kernel-owner+w=401wt.eu-S932720AbYB2Pgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720AbYB2Pgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 10:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760576AbYB2Pg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 10:36:29 -0500
Received: from relay1.sgi.com ([192.48.171.29]:56737 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760546AbYB2Pg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 10:36:26 -0500
Date: Fri, 29 Feb 2008 09:36:22 -0600
From: Paul Jackson <pj@sgi.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee.Schermerhorn@hp.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: trivial clean up to zlc_setup
Message-Id: <20080229093622.2dfb6524.pj@sgi.com>
In-Reply-To: <20080229151057.66ED.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080229151057.66ED.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kosaki-san wrote:
> -       if (jiffies - zlc->last_full_zap > 1 * HZ) {
> +       if (time_after(jiffies, zlc->last_full_zap + HZ)) {

Nice catch.  Thank-you.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
