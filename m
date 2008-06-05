Return-Path: <linux-kernel-owner+w=401wt.eu-S1760732AbYFETOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732AbYFETOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYFETOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:14:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbYFETOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:14:08 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] firewire: fw-ohci: write selfIDBufferPtr before LinkControl.rcvSelfID
Date: Thu, 5 Jun 2008 15:13:27 -0400
User-Agent: KMail/1.9.9
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <tkrat.1dfeb5ce5dd30360@s5r6.in-berlin.de> <tkrat.8c942d590ea22fd3@s5r6.in-berlin.de> <tkrat.999def4a37c1ecd9@s5r6.in-berlin.de>
In-Reply-To: <tkrat.999def4a37c1ecd9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806051513.27568.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2008 02:50:53 pm Stefan Richter wrote:
> OHCI 1.1 clause 5.10 requires that selfIDBufferPtr is valid when a 1 is
> written into LinkControl.rcvSelfID.
>
> This driver bug has so far not been known to cause harm because most
> chips obviously accept a later selfIDBufferPtr write.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

I vaguely recall discussing this one before. Doesn't seem to have caused any 
problems in practice, but yeah, should go ahead and be more spec compliant 
here.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com
