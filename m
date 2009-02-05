Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbZBER4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbZBER4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZBER4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:56:07 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:38853 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZBER4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:56:06 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] floppy: request only the ports we actually use
Date: Thu, 5 Feb 2009 10:55:33 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Philippe De Muyter <phdm@macqel.be>,
       Robert Hancock <hancockrwd@gmail.com>, Adam M Belay <abelay@mit.edu>,
       Len Brown <lenb@kernel.org>
References: <20090205174859.18396.68512.stgit@bob.kio>
In-Reply-To: <20090205174859.18396.68512.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902051055.34149.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009 10:48:59 am Bjorn Helgaas wrote:
> The floppy driver requests an I/O port it doesn't need, and
> sometimes this causes a conflict with a motherboard device
> reported by PNPBIOS.
> 
> This patch makes the floppy driver request only the ports it
> actually uses.
> ...
> Philippe reported that this conflict broke the floppy driver between
> 2.6.11 and 2.6.22.  ...

While this is old and BIOS-specific, it is a regression, so we might
consider it for 2.6.29.

Bjorn
