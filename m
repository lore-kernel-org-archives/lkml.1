Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbZAMUKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbZAMUKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 15:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZAMUKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 15:10:21 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:11220 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZAMUKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 15:10:21 -0500
X-IronPort-AV: E=Sophos;i="4.37,261,1231131600"; 
   d="scan'208";a="65176478"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Bernd Schmidt" <bernds_cb1@t-online.de>
Subject: Re: Fix timeouts in sys_pselect7
Date: Tue, 13 Jan 2009 15:10:07 -0500
User-Agent: KMail/1.9.5
Cc: "Ulrich Drepper" <drepper@gmail.com>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
References: <496CCF94.8050304@t-online.de> <a36005b50901131138p5372aea2ie36243a639c4796b@mail.gmail.com>
In-Reply-To: <a36005b50901131138p5372aea2ie36243a639c4796b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131510.07371.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 13 Jan 2009 20:09:50.0801 (UTC) FILETIME=[E4197410:01C975BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 13 Jan 2009 14:38, Ulrich Drepper pondered:
> On Tue, Jan 13, 2009 at 9:29 AM, Bernd Schmidt <bernds_cb1@t-online.de> wrote:
> > The patch below passes it to
> > core_sys_select instead of &end_time, and this appears to fix the
> > problem.  Does this look like the correct approach?
> 
> Yes, that change is correct.
> 
> > Signed-off-by: Bernd Schmidt <bernd.schmidt@analog.com>
> 
> Reviewed-by: Ulrich Drepper <drepper@redhat.com>

Tested-by: Robin Getz <rgetz@blackfin.uclinux.org>

I'm assuming this should go into stable then?
