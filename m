Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbZBEMSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbZBEMSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 07:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZBEMRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 07:17:51 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:63174 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbZBEMRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 07:17:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEAMdniknCTtAn/2dsb2JhbACBbs8qhBYG
Date: Thu, 5 Feb 2009 13:17:45 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam M Belay <abelay@mit.edu>, Robert Hancock <hancockrwd@gmail.com>,
       linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [BUG] pnpbios breaks floppy support
Message-ID: <20090205121745.GA16397@frolo.macqel>
References: <20090131212915.GA19276@frolo.macqel> <49861E88.8060809@gmail.com> <20090202014331.xt99kri8xd0k00k4@webmail.mit.edu> <200902031729.02286.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902031729.02286.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 05:29:01PM -0700, Bjorn Helgaas wrote:

> I think we should just change floppy.c to request only ports
> 2, 4-5, and 7, with something like the patch below.  Philippe,
> can you give it a try?

Your patch solves the problem : no error from the floppy initialisation,
and the floppy works effectively.

Thank you

Philippe
