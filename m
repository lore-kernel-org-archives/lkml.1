Return-Path: <linux-kernel-owner+w=401wt.eu-S1764153AbXHCXTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764153AbXHCXTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 19:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763652AbXHCXTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 19:19:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763651AbXHCXTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 19:19:02 -0400
Message-ID: <46B3B7DF.2070302@redhat.com>
Date: Fri, 03 Aug 2007 19:18:55 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH -mm] libata: add human-readable error value decoding v3
References: <46B36D59.7060803@shaw.ca>
In-Reply-To: <46B36D59.7060803@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2007 02:00 PM, Robert Hancock wrote:
> This adds human-readable decoding of the ATA status and error registers
> (similar to what drivers/ide does) as well as the SATA Serror register to
> libata error handling output.  This prevents the need to pore through
> standards documents to figure out the meaning of the bits in these
> registers when looking at error reports.  Some bits that drivers/ide
> decoded are not decoded here, since the bits are either command-dependent
> or obsolete, and properly parsing them would add too much complexity.
> 

This is really nice.

Maybe make it configurable, though?
