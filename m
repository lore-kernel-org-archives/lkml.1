Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbYGYUyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbYGYUyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYGYUya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:54:30 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:45749 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYGYUy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:54:29 -0400
X-IronPort-AV: E=Sophos;i="4.31,253,1215388800"; 
   d="scan'208";a="69277966"
From: Roland Dreier <rdreier@cisco.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce lower_32_bits() macro
References: <1216998747-16896-1-git-send-email-joerg.roedel@amd.com>
	<4889FA03.6010708@zytor.com>
	<20080725134759.ae19b883.akpm@linux-foundation.org>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 25 Jul 2008 13:54:28 -0700
In-Reply-To: <20080725134759.ae19b883.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 25 Jul 2008 13:47:59 -0700")
Message-ID: <ada63qtvg57.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Jul 2008 20:54:28.0571 (UTC) FILETIME=[A11FBAB0:01C8EE98]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > There's some readability benefit.  Sometimes it is hard to understand
 > why some random open-coded cast was used.  But I seem to recall that
 > there was another reason why we decided we needed this.  I forget, and
 > so apparently did the changelog author ;)

The guy who added the macro explained it in a comment ;)

 * A basic shift-right of a 64- or 32-bit quantity.  Use this to suppress
 * the "right shift count >= width of type" warning when that quantity is
 * 32-bits.

 - R.
