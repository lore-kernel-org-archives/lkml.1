Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbZBGMpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbZBGMpf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 07:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZBGMp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 07:45:27 -0500
Received: from ozlabs.org ([203.10.76.45]:44987 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbZBGMp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 07:45:26 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anders Kaseorg <andersk@mit.edu>
Subject: Re: [PATCH 4/7] Ksplice: Add module_data_address (the analogue of module_text_address)
Date: Sat, 7 Feb 2009 23:15:10 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Jeff Arnold <jbarnold@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
       Tim Abbott <tabbott@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Nikanth Karthikesan <knikanth@suse.de>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <200902042151.35977.rusty@rustcorp.com.au> <alpine.DEB.2.00.0902041455140.32142@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.2.00.0902041455140.32142@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902072315.13521.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009 07:18:36 Anders Kaseorg wrote:
> On Wed, 4 Feb 2009, Rusty Russell wrote:
> > Does this mean you really want module_data_address, or you actually want
> > a module_address()?
> 
> Yeah, that works better.

Ah, my point was that I can then implement module_text_address in terms
of module_address too.

I'm just about to dump out the module series I've got for 2.6.30; I've
included your ksplice module.c patches or equiv.

Cheers,
Rusty.
