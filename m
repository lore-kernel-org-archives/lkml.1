Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbYA1Wcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbYA1Wcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYA1Wc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:32:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbYA1WcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:32:25 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fail open() quickly if the node doesn't exist anymore
Date: Mon, 28 Jan 2008 17:32:03 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux1394-devel@lists.sourceforge.net,
       Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
References: <tkrat.e1db90404aee1115@s5r6.in-berlin.de> <tkrat.a4603d89e4c2fde1@s5r6.in-berlin.de> <tkrat.340b4530dff1f75a@s5r6.in-berlin.de>
In-Reply-To: <tkrat.340b4530dff1f75a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281732.03912.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008 12:21:56 pm Stefan Richter wrote:
> Scenario:  Process A keeps the character device file of node N open.
> N is being unplugged.  File /dev/fwN won't be destroyed as long as A
> doesn't close it.  Now, process B opens /dev/fwN as well.  Previously
> it would succeed but be unable to do any IO on it of course.  With this
> patch, process B's open() will fail immediately with -ENODEV.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Makes perfect sense to me, no problems with it in cursory testing.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com
