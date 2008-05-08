Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbYEHBOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbYEHBOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 21:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYEHBOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 21:14:37 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:36109 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751285AbYEHBOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 21:14:36 -0400
Message-ID: <482253F7.7070501@davidnewall.com>
Date: Thu, 08 May 2008 10:44:31 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Soumyadip Das Mahapatra <dip_kernel@yahoo.co.in>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: improved strnicmp in lib/string.c
References: <116786.40929.qm@web94104.mail.in2.yahoo.com>
In-Reply-To: <116786.40929.qm@web94104.mail.in2.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soumyadip Das Mahapatra wrote:
> This is somewhat improved version of strnicmp() function in lib/string.c. I have implemented binary
> comparison  rather than linear one(which was in the older version).

It doesn't correctly indicate the sort order.  For example, when
comparing "accdd" against "abcde", it indicates that the first string
sorts before the second (which is wrong.)
