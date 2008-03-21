Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYCUCNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYCUCNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 22:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYCUCMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 22:12:51 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33516 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbYCUCMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 22:12:51 -0400
Date: Fri, 21 Mar 2008 03:12:49 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Joe Perches <joe@perches.com>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add definitions of USHRT_MAX
In-Reply-To: <1206064278.26345.108.camel@localhost>
Message-ID: <alpine.LNX.1.00.0803210312400.10642@fbirervta.pbzchgretzou.qr>
References: <1206063614.14496.72.camel@ymzhang> <1206064278.26345.108.camel@localhost>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 20 2008 18:51, Joe Perches wrote:
> On Fri, 2008-03-21 at 09:40 +0800, Zhang, Yanmin wrote:
>> Add definitions of USHRT_MAX and others into kernel. ipc uses it and
>> slub implementation might also use it.
>> +#define USHRT_MAX	((u16)(~0U))
>> +#define SHRT_MAX	((s16)(USHRT_MAX>>1))
>> +#define SHRT_MIN	(-SHRT_MAX - 1)
>
> Perhaps it's better to use the most common kernel types?
> Perhaps U16_MAX, S16_MAX and S16_MIN?
>
> Don't you need to cast SHRT_MIN/S16_MIN too?
> #define S16_MIN ((s16)(-SHRT_MAX - 1))

SHRT_MAX is already s16.
