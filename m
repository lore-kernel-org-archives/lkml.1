Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbYDMCTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbYDMCTL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 22:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYDMCS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 22:18:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbYDMCS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 22:18:56 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] firewire: fw-ohci: extend logging of bus generations and node ID
Date: Sat, 12 Apr 2008 22:18:41 -0400
User-Agent: KMail/1.9.9
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <tkrat.f3c267b896f5d604@s5r6.in-berlin.de> <tkrat.af66976aaf531c2f@s5r6.in-berlin.de>
In-Reply-To: <tkrat.af66976aaf531c2f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804122218.41123.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 April 2008 06:51:15 pm Stefan Richter wrote:
> Extend the logging of "AR evt_bus_reset, link internal" to "AR
> evt_bus_reset, generation ${selfIDGeneration}".  That way we can check
> whether this generation matches the one seen in self ID complete event
> logging.  See OHCI 1.1 clause 8.4.2.3.
>
> Also extend logging of "firewire_ohci: * selfIDs, generation *" by
> "local node ID ffc*" in self ID logging to make the local node in AT/AR
> event logs more obvious.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---

Good addition for debugging purposes.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com
