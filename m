Return-Path: <linux-kernel-owner+w=401wt.eu-S1751279AbZHXCUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279AbZHXCUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 22:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbZHXCUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 22:20:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbZHXCUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 22:20:32 -0400
Date: Sun, 23 Aug 2009 23:20:28 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: jirislaby@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NET: llc, zero sockaddr_llc struct
Message-ID: <20090824022028.GE6709@ghostprotocols.net>
References: <1250967535-30692-1-git-send-email-jirislaby@gmail.com> <20090823.185617.36449822.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090823.185617.36449822.davem@davemloft.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Aug 23, 2009 at 06:56:17PM -0700, David Miller escreveu:
> From: Jiri Slaby <jirislaby@gmail.com>
> Date: Sat, 22 Aug 2009 20:58:55 +0200
> 
> > sllc_arphrd member of sockaddr_llc might not be set. Zero sllc
> > before copying it to the above layers.
> > 
> > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> > Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> 
> I know it seems arbitrary, but could you please memset() on the
> structure instead of using an empty initializer so that it's
> consistent with how all other ->getname() implementations deal with
> this issue?
> 
> It's easier to audit that way.

Or just set the uninitialized field to zero. But yeah, if what other
implementations are doing is to memset it to zero... maybe its more
clear from a quick glance :-)

- Arnaldo
