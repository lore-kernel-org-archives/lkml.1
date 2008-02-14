Return-Path: <linux-kernel-owner+w=401wt.eu-S1763692AbYBNKFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763692AbYBNKFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 05:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYBNKFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 05:05:34 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4724 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbYBNKFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 05:05:33 -0500
Date: Thu, 14 Feb 2008 10:06:32 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in checkpatch (on pointers to typedefs?)
Message-ID: <20080214100617.GB10713@shadowen.org>
References: <20080210143240.GA13317@joi> <Pine.LNX.4.64.0802132043410.29154@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802132043410.29154@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 08:43:58PM +0100, Jan Engelhardt wrote:
> 
> On Feb 10 2008 15:33, Marcin Slusarz wrote:
> >Checkpatch in current mainline outputs following errors:
> >
> >$ ./scripts/checkpatch.pl -q --file ./fs/udf/misc.c
> >ERROR: need consistent spacing around '*' (ctx:WxV)
> >#205: FILE: fs/udf/misc.c:205:
> >+       tag *tag_p;
> >            ^
> 
> I'd say "don't add any new typedefs" (and perhaps get rid of old ones).

It should be doing that at the site of the new typedef :)

-apw
