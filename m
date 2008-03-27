Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbYC0TLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbYC0TLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYC0TL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:11:29 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4783 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbYC0TL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:11:29 -0400
Subject: Re: [PATCH 1/7] [NET]: uninline skb_put, de-bloats a lot
From: Joe Perches <joe@perches.com>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Matt Mackall <mpm@selenic.com>
In-Reply-To: <1206621486-5408-2-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1206621486-5408-1-git-send-email-ilpo.jarvinen@helsinki.fi>
	 <1206621486-5408-2-git-send-email-ilpo.jarvinen@helsinki.fi>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 27 Mar 2008 12:10:50 -0700
Message-Id: <1206645050.4849.77.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 14:38 +0200, Ilpo Järvinen wrote:
> Allyesconfig (v2.6.24-mm1):

I think this change is only good in severely memory
limited uses.  This will very likely negatively impact
high speed networking.  It's a speed/size trade off.

Perhaps a CONFIG option to reduce net code size would
be appropriate.

