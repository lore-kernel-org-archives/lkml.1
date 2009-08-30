Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbZH3N4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbZH3N4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 09:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbZH3N4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 09:56:33 -0400
Received: from solo.fdn.fr ([80.67.169.19]:56483 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbZH3N4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 09:56:32 -0400
X-Greylist: delayed 994 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Aug 2009 09:56:32 EDT
Date: Sun, 30 Aug 2009 15:39:57 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: MAX_ARG_STRLEN too small?
Message-ID: <20090830133957.GJ10425@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I wanted to pass edos-debcheck a big list of packages (10000), but exec
returns E2BIG, because that reaches MAX_ARG_STRLEN which is (PAGE_SIZE
* 32). Comment says “MAX_ARG_STRLEN is essentially random but serves
to prevent the kernel from being unduly impacted by misaddressed
pointers.”

Aren't there other ways to avoid the issue and permit not-so-bounded
args?

Samuel
