Return-Path: <linux-kernel-owner+w=401wt.eu-S1751438AbZIYEM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbZIYEM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 00:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZIYEM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 00:12:56 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:48808 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZIYEMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 00:12:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        b=PQfBpTMb9jLtN6b7RhL8O3zCaJxyOGwaD7wxREDGtRFPRM2AMv2Id+yzPqeCDWoLNk
         Zxn8N6BQRKNV1eTA5mRjAtUgNWLKLxp2nl8HGEWFheqExhRRD+4ywGmnU0vKQuYwK651
         vFwVgPyDpX18fDgOngnDbTPttUFyNT20Qbr8A=
MIME-Version: 1.0
In-Reply-To: <20090925035825.GB12810@linux-sh.org>
References: <20090925035825.GB12810@linux-sh.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 25 Sep 2009 00:12:39 -0400
Message-ID: <8bd0f97a0909242112p66f6d94cy72ef837ea3bfe393@mail.gmail.com>
Subject: Re: [PATCH] mtd/maps: gpio-addr-flash: Fix up the GENERIC_GPIO=n 
	build.
To: Paul Mundt <lethal@linux-sh.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Bryan Wu <cooloney@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 23:58, Paul Mundt wrote:
> linux/gpio.h takes care of wrapping in to asm/gpio.h or defining a stubbed out
> interface. gpio-addr-flush unfortunately references asm/gpio.h directly and as
> a result blows up when CONFIG_GENERIC_GPIO is disabled.

ive posted two patches for these issues already to the mtd list.  you
can find them here:
http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=shortlog;h=for-mtd
-mike
