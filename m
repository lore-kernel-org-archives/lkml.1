Return-Path: <linux-kernel-owner+w=401wt.eu-S1761682AbYFETK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761682AbYFETK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYFETKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:10:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbYFETKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:10:51 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] firewire: fw-ohci: disable PHY packet reception into AR context
Date: Thu, 5 Jun 2008 15:10:13 -0400
User-Agent: KMail/1.9.9
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <tkrat.1dfeb5ce5dd30360@s5r6.in-berlin.de> <tkrat.8c942d590ea22fd3@s5r6.in-berlin.de>
In-Reply-To: <tkrat.8c942d590ea22fd3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806051510.13657.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2008 02:49:38 pm Stefan Richter wrote:
> We want the rcvPhyPkt bit in LinkControl off before we start using the
> chip.  However, the spec says that the reset value of it is undefined.
> Hence switch it explicitly off.
>
> https://bugzilla.redhat.com/show_bug.cgi?id=244576#c48 shows that for
> example the nForce2 integrated FireWire controller seems to have it on
> by default.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Good catch.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com
