Return-Path: <linux-kernel-owner+w=401wt.eu-S1751370AbZG3ROb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbZG3ROb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbZG3RO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:14:29 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:44861 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZG3RO1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:14:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAD1ycUqrR7PE/2dsb2JhbAC7cognkC0FhBGBTg
X-IronPort-AV: E=Sophos;i="4.43,296,1246838400"; 
   d="scan'208";a="180638794"
From: Roland Dreier <rdreier@cisco.com>
To: lkml@MoreThan.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Uni-processor interrupt state preservation.
References: <200907301137.22035.lkml@morethan.org> <adabpn2rty9.fsf@cisco.com>
	<200907301201.12197.lkml@morethan.org>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 30 Jul 2009 10:14:26 -0700
In-Reply-To: <200907301201.12197.lkml@morethan.org> (Michael S. Zick's message
	of "Thu, 30 Jul 2009 12:01:09 -0500")
Message-ID: <ada7hxqrt3h.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 30 Jul 2009 17:14:27.0136 (UTC) FILETIME=[314C1C00:01CA1139]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > If it does, then that is the answer to my question -
 > Link to the ABI document please.

www.sco.com/developers/devspecs/abi386-4.pdf:

   Registers %ebp, %ebx, %edi, %esi, and %esp ‘‘belong’’ to the cal-
   ling function. In other words, a called function must preserve these
   registers’ values for its caller.
