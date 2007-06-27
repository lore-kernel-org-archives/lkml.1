Return-Path: <linux-kernel-owner+w=401wt.eu-S1760169AbXF0R5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169AbXF0R5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758630AbXF0R5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:57:08 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59646
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762871AbXF0R5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:57:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] hw_random: add quality categories
Date: Wed, 27 Jun 2007 19:56:29 +0200
User-Agent: KMail/1.9.6
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200706241555.22957.mb@bu3sch.de> <200706271458.51884.mb@bu3sch.de> <20070627164041.GA6508@khazad-dum.debian.net>
In-Reply-To: <20070627164041.GA6508@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706271956.29244.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 June 2007 18:40:41 Henrique de Moraes Holschuh wrote:
> There *is* a much better way to deal with it, though.  Add the fail always
> RNG device, and always select it by default.  Let the user specifically set
> which RNG he wants, and it now rates as "trusted", which is the only
> fail-proof way to go about it IMHO.

Well, but it changes ABI, which is forbidden.
After a kernel update your system will partially not work anymore.

-- 
Greetings Michael.
