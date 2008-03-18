Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYCRFKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYCRFKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYCRFKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:10:19 -0400
Received: from ag-out-0708.google.com ([72.14.246.245]:36816 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbYCRFKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:10:18 -0400
Message-ID: <fa686aa40803172210o186e5cb9u113c5c2481c4e730@mail.gmail.com>
Date: Mon, 17 Mar 2008 23:10:01 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Paul Gortmaker" <paul.gortmaker@windriver.com>
Subject: Re: powerpc: cuImage.* creation error
Cc: "Adrian Bunk" <bunk@kernel.org>, "Kumar Gala" <galak@kernel.crashing.org>,
       "Paul Mackerras" <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <fa686aa40803171622j2183369ei7b384ada72d329d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080317193652.GA9550@cs181133002.pp.htv.fi>
	 <20080317200754.GA7383@windriver.com>
	 <fa686aa40803171541t6357d304i2e7e5292f084d09d@mail.gmail.com>
	 <20080317224607.GA10732@windriver.com>
	 <fa686aa40803171622j2183369ei7b384ada72d329d6@mail.gmail.com>
X-Google-Sender-Auth: 5a21863a77730933
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 5:22 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Mar 17, 2008 at 4:46 PM, Paul Gortmaker
>  >     The wrapper script didn't have entries for the TQM8540 board and the
>  >     SBC8548 or SBC8560 boards.  I've assumed that the TQM8540 console is
>  >     8250 based and not CPM based by looking at its defconfig.  There was
>  >     also a trailing * on the TQM8555 entry that I removed too.
>  >
>  >
>  >     Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>  Acked-by: Grant Likely <grant.likely@secretlab.ca>

Actually, I looked again and tweaked a few details in the patch (it
was duplicating an existing clause in the wrapper script).  I'm just
about to post the edited version which I've tested in my environment.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
