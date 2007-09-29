Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbXI2WSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbXI2WSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 18:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbXI2WSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 18:18:37 -0400
Received: from smtprelay11.ispgateway.de ([80.67.29.28]:54802 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbXI2WSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 18:18:37 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [patch] Combine path_put and path_put_conditional
Date: Sun, 30 Sep 2007 00:21:30 +0200
User-Agent: KMail/1.9.6
Cc: jblunck@suse.de, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@lst.de, tiwai@suse.de
References: <20070927141200.820970144@X40.localnet> <200709282243.51243.agruen@suse.de>
In-Reply-To: <200709282243.51243.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709300021.32077.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Friday 28 September 2007, Andreas Gruenbacher wrote:
> The name path_put_conditional (formerly, dput_path) is a little unclear.
> Replace (path_put_conditional + path_put) with path_walk_put_both,
> "put a pair of paths after a path_walk" (see the kerneldoc).
         ^^^^^^^^^^^^^

So why not name it path_walk_put_pair() then?

Rationale: "_both" is just counting, "_pair" 
	means they are related somehow.


Best regards

Ingo Oeser
