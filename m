Return-Path: <linux-kernel-owner+w=401wt.eu-S1751545AbXB1Tky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbXB1Tky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXB1Tkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:40:53 -0500
Received: from smtp.nokia.com ([131.228.20.171]:47715 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbXB1Tkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:40:51 -0500
Subject: Re: [PATCH 5/5] jffs2: Allow selection of compression mode via a
	sysfs attribute
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Richard Purdie <rpurdie@openedhand.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       herbert@gondor.apana.org.au, linux-mtd <linux-mtd@lists.infradead.org>,
       linux-crypto@vger.kernel.org
In-Reply-To: <1172690034.16062.144.camel@localhost.localdomain>
References: <1172690034.16062.144.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Wed, 28 Feb 2007 21:39:43 +0200
Message-Id: <1172691583.17031.35.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 28 Feb 2007 19:39:48.0374 (UTC) FILETIME=[34CE2B60:01C75B70]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Wed, 2007-02-28 at 19:13 +0000, Richard Purdie wrote:
> +/* gives us jffs2_subsys */
> +static decl_subsys(jffs2, NULL, NULL);

There is actually a file-system subsys - look up for fs_subsys. It is
declared at fs/namespace.c.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

