Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbZFTOxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbZFTOxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 10:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZFTOxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 10:53:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42665 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbZFTOxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 10:53:45 -0400
Date: Sat, 20 Jun 2009 10:45:39 -0400
From: Dave Jones <davej@redhat.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [POWERNOW PATCH] x86: powernow-k8 move power management MSRs
	declaration to msr-index.h
Message-ID: <20090620144539.GA19293@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	x86 maintainers <x86@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1245493581.8613.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245493581.8613.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 03:56:21PM +0530, Jaswinder Singh Rajput wrote:
 > 
 > Keep all MSRs declaration in msr-index.h to easily access MSRs declaration.
 > 
 > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

The objection I have to this, is that there's no other use for these MSRs
outside of a powernow driver. They aren't "power management MSRs"
they're "powernow MSRs".

IMO msr-index should be used for MSRs that may be used by multiple files,
reducing duplication.  Here we're just moving something around for
no obvious benefit.

	Dave

