Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbXFDPhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbXFDPhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbXFDPhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:37:23 -0400
Received: from outbound-mail-76.bluehost.com ([69.89.22.25]:33639 "HELO
	outbound-mail-76.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757266AbXFDPhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:37:20 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Olivier Galibert <galibert@pobox.com>
Subject: Re: [PATCH -mm] 1/2: MMCONFIG: validate against ACPI motherboard resources
Date: Mon, 4 Jun 2007 08:37:10 -0700
User-Agent: KMail/1.9.6
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <465CF794.1070406@shaw.ca> <20070604121250.GA33621@dspnet.fr.eu.org>
In-Reply-To: <20070604121250.GA33621@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706040837.10720.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 4, 2007 5:12:50 Olivier Galibert wrote:
> On Tue, May 29, 2007 at 10:03:32PM -0600, Robert Hancock wrote:
> > -Validate that the area is reserved even if we read it from the
> > chipset directly and not from the MCFG table. This catches the case
> > where the BIOS didn't set the location properly in the chipset and
> > has mapped it over other things it shouldn't have.
>
> Just for the record, I still fundamentally disagree with that part.
> You're not catching what you think you're catching, since the chipset
> tells you what it is going to decode as mmconfig, no matter what is
> connected to it.

I'm not sure what you're objecting to?  Are you suggesting that we use 
mmconfig space as defined by the bridge register even if it's not mentioned 
(or doesn't match) the MCFG table?

Jesse
