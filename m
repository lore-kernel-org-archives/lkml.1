Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbZG3Q4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbZG3Q4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 12:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZG3Q4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 12:56:00 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:14202 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbZG3Qz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 12:55:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAENtcUqrR7PE/2dsb2JhbAC7SognkCsFhBE
X-IronPort-AV: E=Sophos;i="4.43,296,1246838400"; 
   d="scan'208";a="191257498"
From: Roland Dreier <rdreier@cisco.com>
To: lkml@MoreThan.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Uni-processor interrupt state preservation.
References: <200907301137.22035.lkml@morethan.org>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 30 Jul 2009 09:55:58 -0700
In-Reply-To: <200907301137.22035.lkml@morethan.org> (Michael S. Zick's message
	of "Thu, 30 Jul 2009 11:37:18 -0500")
Message-ID: <adabpn2rty9.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jul 2009 16:55:59.0181 (UTC) FILETIME=[9CE797D0:01CA1136]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Just how is the interrupt state (in ebx) supposed to be preserved across
 > the function call?

Doesn't the i386 ABI say that ebx is preserved across function calls?
