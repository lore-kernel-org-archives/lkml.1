Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbYEVQ7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbYEVQ7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYEVQ7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:59:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:50183 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbYEVQ7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:59:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=CuZTaNC4/GijziMx+Q8JgcESfk7zHU6Bw7pOmRFN1oMC6ozSdXx+o4bd0nlnFdlDTK6irT8GTDEZRA8jJBPAsUwAierL/dHA91PkhmqcCyBgqgUfSEZNHKJgO0A3DbJ1WLaXtYjFVDPyywbWxN4McsZJBKMLl61/jHCmvFcuJfQ=
Date: Thu, 22 May 2008 18:58:45 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH] ERR_PTR: warn when ERR_PTR parameter is invalid
Message-ID: <20080522165841.GA5648@joi>
References: <1211475019-5596-1-git-send-email-marcin.slusarz@gmail.com> <1211475019-5596-2-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211475019-5596-2-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, wrong patch title. Should be:
"ERR_PTR: warn when ERR_PTR parameter is invalid"

I forgot to add that this patch sould be applied after:
"vfs: fix ERR_PTR abuse in generic_readlink"
http://lkml.org/lkml/2008/5/18/316
which is alredy in -mm

Cheers,
Marcin
