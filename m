Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbZBFL5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbZBFL5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 06:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbZBFL5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 06:57:39 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:59615 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZBFL5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 06:57:38 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Dirk DeSchepper" <ddeschepper@nvtl.com>,
       USB development list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 001/001]  usbserial: New mobile broadband modems to be supported through option module
Date: Fri, 6 Feb 2009 12:58:39 +0100
User-Agent: KMail/1.9.10
Cc: "Greg KH" <greg@kroah.com>, smurf@smurf.noris.de,
       linux-kernel@vger.kernel.org
References: <12047829252365@kroah.org> <20090206003352.GA22530@kroah.com> <B29F014DE7B1F949B0BC4C1EBCF29DD6C6D2A3@Vectra.nvtl.local>
In-Reply-To: <B29F014DE7B1F949B0BC4C1EBCF29DD6C6D2A3@Vectra.nvtl.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902061258.40303.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Friday 06 February 2009 12:29:06 schrieb Dirk DeSchepper:
> From: Dirk De Schepper <ddeschepper@nvtl.com>
> 
> Patch for option.c, based on kernel v2.6.28.3
> - New Novatel and Dell mobile broadband modem products added
> - Dell pid variables used in stead of numerical PIDs for known products

This is not really an advantage. You usually get the nummeric IDs
just fine from lsusb. And you could easily see the nummeric order of entries.
These symbolic names do not appear in code, just in the macros
where their meaning is clear. You introduce a useless level of indirection.

	Regards
		Oliver
