Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbYFKONM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbYFKONM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYFKOM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:12:58 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:52113 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbYFKOM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:12:58 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jun 2008 10:12:57 EDT
X-IronPort-AV: E=Sophos;i="4.27,624,1204520400"; 
   d="scan'208";a="557447"
Date: Wed, 11 Jun 2008 15:03:04 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Jiri Bohac <jbohac@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console keyboard mapping broken by 04c71976
Message-ID: <20080611140304.GM4244@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Jiri Bohac <jbohac@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20080611134837.GA11462@midget.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611134837.GA11462@midget.suse.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-OriginalArrivalTime: 11 Jun 2008 14:03:03.0879 (UTC) FILETIME=[DDB9A570:01C8CBCB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Err, at quick look it looks to me rather like a bug kbd, which doesn't
cope with the console being in unicode mode.  Which distribution are you
using?

In unicode mode, k_self is really meant to hold unicode values (there is
no other way to provide an arbitrary unicode value in keyboard maps),
and thus kbd should translate KT_LETTER's value from the map file's
encoding (set by the charset directive) to unicode.

Samuel
