Return-Path: <linux-kernel-owner+w=401wt.eu-S1032301AbXEHVTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032301AbXEHVTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032202AbXEHVTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:19:43 -0400
Received: from dialup.esmr.ru ([85.94.3.83]:36921 "EHLO localhost.localdomain"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031844AbXEHVTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:19:42 -0400
Date: Wed, 9 May 2007 01:19:16 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-pcmcia@lists.infradead.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [POWERPC] 8xx: mpc885ads pcmcia support
Message-ID: <20070509011916.60853128@localhost.localdomain>
In-Reply-To: <774F0168-051E-4C6B-9292-8EE731E6D889@kernel.crashing.org>
References: <20070508095001.20018.85403.stgit@localhost.localdomain>
	<20070508095038.20018.60060.stgit@localhost.localdomain>
	<774F0168-051E-4C6B-9292-8EE731E6D889@kernel.crashing.org>
X-Mailer: Claws Mail 2.9.1cvs42 (GTK+ 2.10.11; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 09:04:22 -0500
Kumar Gala wrote:

> > +			device_type = "pcmcia";
> > +			reg = <80 80>;
> > +			clock-frequency = <2faf080>;  
> 
> is the clock-freq fixed?
As I see now, that field is not really required as never extracted or used. The intention was to
use dts value iirc, later it was switched to ppc_proc_freq, but never removed from dts.

Hence I'll do that now.
-- 
Sincerely, Vitaly

