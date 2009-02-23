Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZBWNVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZBWNVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 08:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZBWNVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 08:21:32 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39197 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbZBWNVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 08:21:32 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 23 Feb 2009 14:21:10 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firedtv: reinstate debug logging option
To: Henrik Kurelid <henke@kurelid.se>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.32631eff43fd494b@s5r6.in-berlin.de>
Message-ID: <tkrat.5b9aa1f76fe139a4@s5r6.in-berlin.de>
References: <49A1BDA2.9080302@s5r6.in-berlin.de>
 <675fd9b9fc8aff6ca0bed1f7cc42b286.squirrel@mail.kurelid.se>
 <49A26223.7000507@s5r6.in-berlin.de>
 <tkrat.32631eff43fd494b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> +MODULE_PARM_DESC(debug, "Verbose logging (default = 0"
> +	", FCP subactions = "	__stringify(AVC_DEBUG_FCP_SUBACTIONS)
> +	", FCP payloads = "	__stringify(AVC_DEBUG_FCP_PAYLOADS)
> +	", or all = -1)");

I think I should #include <linux/stringify.h> for that.
-- 
Stefan Richter
-=====-==--= --=- =-===
http://arcgraph.de/sr/

