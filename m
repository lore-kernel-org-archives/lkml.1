Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898Ab0AUTdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab0AUTdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 14:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932118Ab0AUTdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 14:33:31 -0500
Received: from quechua.inka.de ([193.197.184.2]:44477 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab0AUTda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 14:33:30 -0500
X-Greylist: delayed 1327 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jan 2010 14:33:30 EST
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] lib: revise list_sort() comment
References: <87fx609i29.fsf@gmail.com> <877hrc9guw.fsf@gmail.com>
Organization: private Linux site, southern Germany
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: Olaf Titz <olaf@bigred.inka.de>
Date: Thu, 21 Jan 2010 20:11:16 +0100
Message-ID: <E1NY2R2-0007nJ-Ic@bigred.inka.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + * The comparison function @cmp must return a negative value if @a
> + * should sort before @b, and a positive value if @a should sort after
> + * @b. If @a and @b are equivalent, and their original relative
> + * ordering is to be preserved, @cmp should return 0; otherwise, the
> + * return value does not matter.

This "otherwise... does not matter" sounds funny and confusing. Either
read this as "the return value does not matter if it is neither <0, >0
or ==0" or "the return value does not matter if the function wants it
to be ignored". :-)

Just omitting the "otherwise" clause would be clearer.

Olaf
