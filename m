Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYAFKF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYAFKF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 05:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYAFKFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 05:05:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60534 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYAFKFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 05:05:21 -0500
Subject: Re: [patch 3/5] Add the end-of-trace marker and the module list to
	WARN_ON()
From: David Woodhouse <dwmw2@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, olof@lixom.net, mingo@elte.hu,
       mpm@selenic.com
In-Reply-To: <20080105191044.23712dc7@laptopd505.fenrus.org>
References: <20080105190713.73745ec6@laptopd505.fenrus.org>
	 <20080105191044.23712dc7@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 10:04:06 +0000
Message-Id: <1199613846.4111.325.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-05 at 19:10 -0800, Arjan van de Ven wrote:
> Another issue is that, unlike oopses, WARN_ON() doesn't currently
> printk the helpful "cut here" line, 

I'd rather see the 'cut here' line disappear altogether. Often, the
line(s) which come immediately before it are extremely relevant to the
problem. Cutting them is bad.

-- 
dwmw2

