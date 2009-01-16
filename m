Return-Path: <linux-kernel-owner+w=401wt.eu-S934882AbZAPV7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882AbZAPV7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 16:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937185AbZAPV72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 16:59:28 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:27567 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937065AbZAPV70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 16:59:26 -0500
X-IronPort-AV: E=Sophos;i="4.37,278,1231113600"; 
   d="scan'208";a="130112429"
From: Roland Dreier <rdreier@cisco.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] infiniband: remove __constant_{endian} uses
References: <1232065920.11986.3.camel@brick>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 16 Jan 2009 13:59:25 -0800
In-Reply-To: <1232065920.11986.3.camel@brick> (Harvey Harrison's message of
	"Thu, 15 Jan 2009 16:32:00 -0800")
Message-ID: <ada4ozyewua.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Jan 2009 21:59:25.0409 (UTC) FILETIME=[B21C4510:01C97825]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Roland, the necessary byteorder rework is now in -linus mainline
 > and all arches have moved over, I'm starting to remove the uses
 > of the __constant_* helpers now that they are equivalent.

This looks good, thanks.  I assume the expectation is that this should
be queued for the next merge window?

Code generation should be unaffected, right?

 - R.
