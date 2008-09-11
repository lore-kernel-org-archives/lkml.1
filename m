Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYIKSQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYIKSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYIKSQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:16:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55992 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbYIKSQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:16:17 -0400
Subject: Re: [PATCH 1/2] audit: fix NUL handling in untrusted strings
From: Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>
To: John Dennis <jdennis@redhat.com>
Cc: linux-audit <linux-audit@redhat.com>, viro@zeniv.linux.org.uk,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1221156612.17533.14.camel@amilo>
References: <1221085418.2705.19.camel@amilo>
	 <1221143113.2992.9.camel@localhost.localdomain>
	 <48C955C8.2000602@redhat.com>  <1221156612.17533.14.camel@amilo>
Content-Type: text/plain; charset=utf-8
Date: Thu, 11 Sep 2008 20:15:11 +0200
Message-Id: <1221156911.17533.17.camel@amilo>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miloslav Trmač píše v Čt 11. 09. 2008 v 20:10 +0200:
> Yes, that's possible - but then audit_log_n_untrustedstring() would be
> more accurately called audit_log_n_ascii_like_binary_data().
... my original patch (which stops at the first NUL) works the same way
the other interfaces with maximum string length (e.g. strnlen() or
printf ("%.5s", ...)) do.
	Mirek

