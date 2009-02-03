Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbZBCE5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbZBCE5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZBCE4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:56:48 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:49694 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbZBCE4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:56:47 -0500
Date: Tue, 3 Feb 2009 05:58:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: andrew@walrond.org, jengelh@medozas.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.28 headers break kbd and net-tools userspace builds
Message-ID: <20090203045833.GA11639@uranus.ravnborg.org>
References: <20090202.120507.152093960.davem@davemloft.net> <498761E7.3080006@walrond.org> <20090202.132450.21504465.davem@davemloft.net> <20090202.132723.38842373.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090202.132723.38842373.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 01:27:23PM -0800, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 02 Feb 2009 13:24:50 -0800 (PST)
> 
> > I guess I'll put in the following hack for now:
> > 
> > diff --git a/include/linux/if_tunnel.h b/include/linux/if_tunnel.h
> > index aeab2cb..82c4362 100644
> 
> Need to also update linux/Kbuild, here is an updated patch:

All headers are unifdeffed - so the Kbuild patch
is not needed.

	Sam
