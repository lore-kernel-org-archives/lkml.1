Return-Path: <linux-kernel-owner+w=401wt.eu-S1763968AbXGFR40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763968AbXGFR40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764389AbXGFR4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:56:08 -0400
Received: from zakalwe.fi ([80.83.5.154]:56253 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764374AbXGFR4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:56:07 -0400
Date: Fri, 6 Jul 2007 20:55:52 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: kernel-janitors@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] some kmalloc/memset ->kzalloc (tree wide)
Message-ID: <20070706175552.GF3400@zakalwe.fi>
References: <878x9ta320.fsf@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <878x9ta320.fsf@wanadoo.fr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Transform some calls to kmalloc/memset to a single kzalloc (or 
> kcalloc).

I looked all the files through. They looked good to me, except 
one case:

In drivers/net/hamradio/dmascc.c you removed one comment, and I think 
it should not be removed:

/* Initialize what is necessary for write_scc and write_scc_data */ 

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
