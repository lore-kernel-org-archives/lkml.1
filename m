Return-Path: <linux-kernel-owner+w=401wt.eu-S2992826AbXCIPII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992826AbXCIPII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 10:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992828AbXCIPII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 10:08:08 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:49633 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992826AbXCIPIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 10:08:04 -0500
Date: Fri, 9 Mar 2007 09:07:40 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-security-module@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] [Patch 1/1] IBAC Patch
Message-ID: <20070309150740.GA5948@sergelap.austin.ibm.com>
References: <1173394696.5981.12.camel@localhost.localdomain> <200703090319.l293JrpC009714@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703090319.l293JrpC009714@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu):
> On Thu, 08 Mar 2007 17:58:16 EST, Mimi Zohar said:
> > This is a request for comments for a new Integrity Based Access
> > Control(IBAC) LSM module which bases access control decisions
> > on the new integrity framework services. 
> > 
> > (Hopefully this will help clarify the interaction between an LSM 
> > module and LIM module.)
> 
> OK, between this and the additional LIM hooks I didn't notice in an earlier
> patch, we're starting to see the API.   The only problem is that although
> it may be the right API for *your* code, I suspect it's a non-starter without
> a discussion about whether it's the right *generic* API for an LIM (which will
> require at least one dramatic bun fight about what "Integrity" means).

Casey's earlier message suggested this too.  'Integrity' here in
particular does not mean online integrity guarantees through, i.e.,
information flow control.  So perhaps instead of 'integrity' we should
make sure to always say 'integrity measurement'.  Of course then there
is already the 'integrity measurement architecture' which is only one
implementation of a LIM module, right?   So it would need to be renamed
to TIMA (TPM-enabled IMA) or something I guess.

-serge
