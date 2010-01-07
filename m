Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603Ab0AGV3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab0AGV3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022Ab0AGV3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:29:21 -0500
Received: from ozlabs.org ([203.10.76.45]:52395 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab0AGV3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:29:20 -0500
Date: Fri, 8 Jan 2010 08:29:12 +1100
From: Paul Mackerras <paulus@samba.org>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: add close()/closedir() calls when needed
Message-ID: <20100107212912.GB10344@brick.ozlabs.ibm.com>
References: <1262882447-23776-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262882447-23776-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 07:40:46PM +0300, Alexander Beregalov wrote:

> Close file and directory descriptors before exiting or dying.

Your patch description doesn't say why that's a good thing to do, and
it's not obvious to me at least.  Please explain the motivation in
your patch description.

Paul.
