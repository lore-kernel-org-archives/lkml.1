Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbYLCCMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbYLCCMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 21:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbYLCCML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 21:12:11 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:36329 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbYLCCLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 21:11:44 -0500
Message-ID: <4935EADC.3070407@davidnewall.com>
Date: Wed, 03 Dec 2008 12:41:40 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Geoffrey McRae <geoff@rabidhost.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: New Security Features, Please Comment
References: <1228260494.24232.21.camel@compy.ivent.com.au>	 <20081203005338.6472db7a@lxorguk.ukuu.org.uk> <1228268657.6679.4.camel@lappy.spacevs.com>
In-Reply-To: <1228268657.6679.4.camel@lappy.spacevs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geoffrey McRae wrote:
> But once this set is introduced a HTTP server could be written that uses
> forked children to handle requests, that have their identity swtiched
> before doing any work, including parsing CGI scripts.

But a child could be one user the first time it does work, and another
user the next time.  What prevents the child from opening a file while
the first user, and reading or writing it while the second?  That's
exactly what you don't want to permit.
