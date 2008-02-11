Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbYBKSpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbYBKSpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYBKSpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:45:12 -0500
Received: from mail.suse.de ([195.135.220.2]:42377 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbYBKSpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:45:10 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
Date: Mon, 11 Feb 2008 19:45:05 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111945.05917.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 16:30:32 David Rientjes wrote:
> The mempolicy mode constants, MPOL_DEFAULT, MPOL_PREFERRED, MPOL_BIND,
> and MPOL_INTERLEAVE, are better declared as part of an enum for type
> checking.

What type checking? There is none in standard C for enums.

-Andi
