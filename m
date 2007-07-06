Return-Path: <linux-kernel-owner+w=401wt.eu-S1763166AbXGFWHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763166AbXGFWHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 18:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760834AbXGFWHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 18:07:24 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:46297 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760388AbXGFWHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 18:07:23 -0400
Date: Fri, 6 Jul 2007 18:07:20 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Heikki Orsila <shdl@zakalwe.fi>
cc: Yoann Padioleau <padator@wanadoo.fr>, kernel-janitors@lists.osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] some kmalloc/memset ->kzalloc (tree wide)
In-Reply-To: <20070706175552.GF3400@zakalwe.fi>
Message-ID: <Line.LNX.4.64.0707061806390.18415@d.namei>
References: <878x9ta320.fsf@wanadoo.fr> <20070706175552.GF3400@zakalwe.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Heikki Orsila wrote:

> > Transform some calls to kmalloc/memset to a single kzalloc (or 
> > kcalloc).
> 
> I looked all the files through. They looked good to me, except 
> one case:

I checked the drivers/net and net/ changes and they looked ok (aside from 
the above).


- James
-- 
James Morris
<jmorris@namei.org>
