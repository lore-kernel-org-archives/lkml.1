Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbXDRHYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbXDRHYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 03:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932840AbXDRHYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 03:24:23 -0400
Received: from rwcrmhc13.comcast.net ([204.127.192.83]:50794 "EHLO
	rwcrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837AbXDRHYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 03:24:23 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2007 03:24:23 EDT
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/10]  mount ownership and unprivileged mount syscall (v3)
References: <20070416110308.739051445@szeredi.hu>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Wed, 18 Apr 2007 03:08:07 -0400
In-Reply-To: <20070416110308.739051445@szeredi.hu> (Miklos Szeredi's message
	of "Mon, 16 Apr 2007 13:03:08 +0200")
Message-ID: <87d522kvmw.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110003 (No Gnus v0.3) Emacs/22.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that this might introduce serious denial of service
possibilities due to the fact that many of the file systems are not
robust to invalid on-block-device data.

-- 
Jeremy Maitin-Shepard
