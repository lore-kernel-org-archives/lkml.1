Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYKVGeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYKVGeQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 01:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYKVGeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 01:34:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52427 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbYKVGeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 01:34:09 -0500
Date: Sat, 22 Nov 2008 01:34:07 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Arnold <jbarnold@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [RFC v3 PATCH 6/7] Ksplice: Export symbols needed for Ksplice
Message-ID: <20081122063407.GA13931@infradead.org>
References: <1227324961-13273-1-git-send-email-jbarnold@mit.edu> <1227324961-13273-2-git-send-email-jbarnold@mit.edu> <1227324961-13273-3-git-send-email-jbarnold@mit.edu> <1227324961-13273-4-git-send-email-jbarnold@mit.edu> <1227324961-13273-5-git-send-email-jbarnold@mit.edu> <1227324961-13273-6-git-send-email-jbarnold@mit.edu> <1227324961-13273-7-git-send-email-jbarnold@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227324961-13273-7-git-send-email-jbarnold@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 10:36:00PM -0500, Jeff Arnold wrote:
> Ksplice uses init_mm to get access to the ranges of addresses
> containing core kernel text and data.  It seems that init_mm was
> scheduled to be unexported entirely in 2.6.26, so move it to
> EXPORT_SYMBOL_GPL (rather than back to EXPORT_SYMBOL).

Umm, no.  This is a very clear indicator that your code shouldn't be
modular.

