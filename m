Return-Path: <linux-kernel-owner+w=401wt.eu-S2992448AbXDYJR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992448AbXDYJR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992449AbXDYJR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:17:27 -0400
Received: from ns2.suse.de ([195.135.220.15]:54328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992448AbXDYJR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:17:26 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 09/25] xen: Account for time stolen by Xen
Date: Wed, 25 Apr 2007 11:15:49 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
References: <20070423215638.563901986@goop.org> <20070423215710.867690403@goop.org>
In-Reply-To: <20070423215710.867690403@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704251115.49966.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +
> +	do {
> +		state_time = state->state_entry_time;
> +		barrier();

Should be likely rmb

-Andi
