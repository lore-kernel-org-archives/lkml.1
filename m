Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbYBMToQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbYBMToQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbYBMToA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:44:00 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:38879 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbYBMTn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:43:59 -0500
Date: Wed, 13 Feb 2008 20:43:58 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
cc: Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in checkpatch (on pointers to typedefs?)
In-Reply-To: <20080210143240.GA13317@joi>
Message-ID: <Pine.LNX.4.64.0802132043410.29154@fbirervta.pbzchgretzou.qr>
References: <20080210143240.GA13317@joi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 10 2008 15:33, Marcin Slusarz wrote:
>Checkpatch in current mainline outputs following errors:
>
>$ ./scripts/checkpatch.pl -q --file ./fs/udf/misc.c
>ERROR: need consistent spacing around '*' (ctx:WxV)
>#205: FILE: fs/udf/misc.c:205:
>+       tag *tag_p;
>            ^

I'd say "don't add any new typedefs" (and perhaps get rid of old ones).

