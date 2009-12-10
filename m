Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbZLJMrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbZLJMrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 07:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758705AbZLJMrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 07:47:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758115AbZLJMrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 07:47:04 -0500
Date: Thu, 10 Dec 2009 10:47:06 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net: fix compat_sys_recvmmsg parameter type
Message-ID: <20091210124706.GB20963@ghostprotocols.net>
References: <20091210065815.GA4144@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210065815.GA4144@osiris.boeblingen.de.ibm.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 10, 2009 at 07:58:16AM +0100, Heiko Carstens escreveu:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> compat_sys_recvmmsg has a compat_timespec parameter and not a
> timespec parameter. This way we also get rid of an odd cast.
> 
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Was unaware of this helper, thanks!

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
