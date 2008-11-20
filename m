Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbYKTOIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbYKTOIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbYKTOId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:08:33 -0500
Received: from smtp3.netcologne.de ([194.8.194.66]:35829 "EHLO
	smtp3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbYKTOIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:08:32 -0500
Date: Thu, 20 Nov 2008 15:08:30 +0100
From: Max Kellermann <max@duempel.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: High load in 2.6.27, NFS / rpcauth_lookup_credcache()?
Message-ID: <20081120140830.GA23697@squirrel.roonstrasse.net>
Mail-Followup-To: Trond Myklebust <trond.myklebust@fys.uio.no>,
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
References: <20081022091207.GA12996@squirrel.roonstrasse.net> <20081023123628.GA18549@squirrel.roonstrasse.net> <1224773745.7625.4.camel@localhost> <20081024083913.GA15197@squirrel.roonstrasse.net> <1224871763.22672.33.camel@localhost> <20081027095843.GA10937@squirrel.roonstrasse.net> <1225122503.14242.12.camel@heimdal.trondhjem.org> <20081117123536.GA16539@squirrel.roonstrasse.net> <1227133861.28898.26.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227133861.28898.26.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/11/19 23:31, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> Looking at the above, it seems that you're spending an inordinate amount
> of time in generic_match too.
> Could you see if the following patch helps?

That fixes the problem.  The first kernel symbol in oprofile is the
tg3 network driver at 2%.

Max
