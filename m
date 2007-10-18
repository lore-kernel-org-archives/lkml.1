Return-Path: <linux-kernel-owner+w=401wt.eu-S1761839AbXJRISx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761839AbXJRISx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 04:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbXJRISk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 04:18:40 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:50419
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbXJRISi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 04:18:38 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: David Miller <davem@davemloft.net>
Subject: Re: [2.6 patch] esp_scsi.c: remove __dev{init,exit}
Date: Thu, 18 Oct 2007 03:18:01 -0500
User-Agent: KMail/1.9.6
Cc: bunk@kernel.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1192109439.3352.11.camel@localhost.localdomain> <200710111747.03119.rob@landley.net> <20071011.144928.45188136.davem@davemloft.net>
In-Reply-To: <20071011.144928.45188136.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710180318.01463.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 October 2007 4:49:28 pm David Miller wrote:
> From: Rob Landley <rob@landley.net>
> Date: Thu, 11 Oct 2007 17:47:02 -0500
>
> > On Thursday 11 October 2007 10:35:20 am Adrian Bunk wrote:
> > > Since scsi_esp_{,un}register() are EXPORT_SYMBOL'ed, these functions
> > > (and the functions they use) can't be __dev{init,exit}.
> > >
> > > Based on a bug report by Rob Landley.
> > >
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >
> > Acked-by: Rob Landley <rob@landley.net>
>
> I'm fine with this fix too.
>
> Acked-by: David S. Miller <davem@davemloft.net>

Did this already go to the -stable guys for 2.6.23.2?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
