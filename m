Return-Path: <linux-kernel-owner+w=401wt.eu-S935567AbZLPTXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935567AbZLPTXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935571AbZLPTXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:23:40 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42077 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935399AbZLPTXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:23:37 -0500
Date: Wed, 16 Dec 2009 11:23:34 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Ray Copeland <ray.copeland@aprius.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Arvind Vasudev <arvind.vasudev@aprius.com>
Subject: Re: [PATCH 1/2] Wrong ADT7462_VOLT_COUNT for linux-2.6.30 adt7462
	hwmon driver
Message-ID: <20091216192334.GC10356@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <AFEAE911EE22F64BACAB05ED86B4D4FC018DA312@EXVBE012-13.exch012.intermedia.net> <AFEAE911EE22F64BACAB05ED86B4D4FC018DA31A@EXVBE012-13.exch012.intermedia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AFEAE911EE22F64BACAB05ED86B4D4FC018DA31A@EXVBE012-13.exch012.intermedia.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 09:58:32AM -0800, Ray Copeland wrote:
> From: Ray Copeland <ray.copeland@aprius.com>
> Date: Wed, 16 Dec 2009
> Subject: [PATCH 1/2] Wrong ADT7462_VOLT_COUNT for linux-2.6.30 adt7462 hwmon driver 
> 
> Description:
> 
> The #define ADT7462_VOLT_COUNT is wrong, it should be 13 not 12. All the 
<snip>
> -#define ADT7462_VOLT_COUNT	13
> +#define ADT7462_VOLT_COUNT	12

Uh... I think this patch is reversed?  This part of the diff replaces 13 with
12, which is the opposite of what I think you want.

--D
