Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbYDXWR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbYDXWR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 18:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbYDXWRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 18:17:20 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51080 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbYDXWRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 18:17:19 -0400
Date: Thu, 24 Apr 2008 15:16:46 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2/2] ibmaem: New driver for power/energy meters in IBM
	System X hardware
Message-ID: <20080424221645.GA16404@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20080328213805.GB7183@tree.beaverton.ibm.com> <47F1A675.3050204@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F1A675.3050204@codemonkey.ws>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 10:05:25PM -0500, Anthony Liguori wrote:

> It really shouldn't be necessary to have all of these macro functions.  
> In this above macro, you would just have to pass the ro and rw  
> structures along with a remove function pointer.  Since all of your  
> types have common members, you could just have a common substructure and  
> pass that around.

Hmm... it isn't too difficult to refactor the registration function to
make it easier to look at, though I'd rather keep the AEM1 and AEM2 guts
separate rather than aggressively eliminating macros by making the AEM1
structs a subset of the AEM2 structs.

--D
