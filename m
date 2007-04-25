Return-Path: <linux-kernel-owner+w=401wt.eu-S1031143AbXDYU5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031143AbXDYU5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031139AbXDYU5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:57:30 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:42700 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031143AbXDYU53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:57:29 -0400
X-IronPort-AV: i="4.14,451,1170662400"; 
   d="scan'208"; a="415615736:sNHT327567320"
To: Steve Wise <swise@opengridcomputing.com>
Cc: Roland Dreier <rolandd@cisco.com>, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] [PATCH 6/6] [RFC]mlx4 build system stuff
X-Message-Flag: Warning: May contain useful information
References: <20074201532.jhCN1hLvxaAengJm@cisco.com>
	<1177534219.29222.0.camel@stevo-desktop>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 25 Apr 2007 13:57:20 -0700
In-Reply-To: <1177534219.29222.0.camel@stevo-desktop> (Steve Wise's message of "Wed, 25 Apr 2007 15:50:19 -0500")
Message-ID: <ada1wi8w4sv.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Apr 2007 20:57:20.0440 (UTC) FILETIME=[50C91B80:01C7877C]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > +config MLX4_CORE
 > > +	tristate
 > > +	depends on PCI
 > > +	default n
 > > +
 > 
 > No help menu for the core module?

It's an invisible option.  You get it if you enable anything that uses
it (mlx4_ib or mlx4_eth), and you never even have to know about the
option.

 - R.
