Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbZLNLJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbZLNLJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbZLNLJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:09:30 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45702 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbZLNLJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:09:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vmm95xpVEVmnvoFdLh1VMy/IPm/e8qbTt3hJdhDP9gcqddj/BFGUHMDqmf7f0IaXaG
         DKQaL3hQ63Zwp2ApEqtR9vED+GBUHQtPISR/cxjHtZ4dB2qv2OibR6rO6WKyoXJHG0SL
         eAJwMOX93waxsqSUX0wF1o0XtzYZNbITJWiMs=
Date: Mon, 14 Dec 2009 12:09:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-rc0: reiserfs: inconsistent lock state
Message-ID: <20091214110921.GA5168@nowhere>
References: <a4423d670912111406g5967eb1fw93e49de242fbf54@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670912111406g5967eb1fw93e49de242fbf54@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 01:06:29AM +0300, Alexander Beregalov wrote:
> Hi Frederic
> 
> It is x86_32 UP
> 
> 
> [ INFO: inconsistent lock state ]
> 2.6.32-05594-g3ef884b #2
[...]


Thanks! I've pushed two fixes in my tree. May be could
you test them by merging it on latest upstream?

As usual, it's on:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	reiserfs/kill-bkl

Thanks!

