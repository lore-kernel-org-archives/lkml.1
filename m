Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYCOAIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYCOAIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 20:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYCOAII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 20:08:08 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:33416 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbYCOAIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 20:08:07 -0400
From: Chr <chunkeey@web.de>
To: Milan Broz <mbroz@redhat.com>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
Date: Sat, 15 Mar 2008 01:08:03 +0100
User-Agent: KMail/1.9.9
Cc: David Chinner <dgc@sgi.com>, Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       dm-devel@redhat.com
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080309213441.GQ155407@sgi.com> <47DA44EB.8000307@redhat.com>
In-Reply-To: <47DA44EB.8000307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803150108.04008.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1/U1o324onSvldhpiyuyLF8ofykNHNAM2J2Dhjo
	s0asHvtkGOw46yxEDsm4aOcPaGUV0gD/XPJMoz+s9OthSO3bzo
	zE2YIZSIs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 March 2008 10:27:07 Milan Broz wrote:
>
> > Oh, dm-crypt. Well, I'd definitely start looking there. XFS has a
> > history of exposing dm-crypt bugs, and these hangs appear to be I/O
> > congestion/scheduling related and not XFS. Also, we haven't changed
> > anything related to plug/unplug of block devices in XFS recently, so
> > that also points to some other change as well...
>
> Yes, there is bug in dm-crypt...
> Please try if the patch here helps: http://lkml.org/lkml/2008/3/14/71
>
hmm, :-/

stuck again... (tried the patch on top of 2.6.25-rc5 and 2.6.25-rc5-git4)

SYS-RQ (several times) T+W+Q 
right here:
http://www.pastebin.ca/943145

Regards,
	Christian
