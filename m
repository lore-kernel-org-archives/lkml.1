Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbXEaRtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbXEaRtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 13:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbXEaRtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 13:49:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbXEaRtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 13:49:45 -0400
Message-ID: <465F0AAB.5080807@redhat.com>
Date: Thu, 31 May 2007 13:49:31 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Ruthven <puck@catalyst.net.nz>
CC: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [oops] in bluetooth
References: <1180345089.819.28.camel@lamb>
In-Reply-To: <1180345089.819.28.camel@lamb>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2007 05:38 AM, Andrew Ruthven wrote:
> Just a follow-up to Marcel regarding Pavel's bluetooth oops.  I've had
> the same issue with both 2.6.21 and 2.6.21.2 (skipped .1).  I'm able to
> reproduce the oops.
> 
> My scenario is connecting from a Treo650 via bluetooth to access the
> Internet by my ADSL link.
> 
> The first connection after booting worked just fine, but every attempt
> after that failed with a oops.
> 
> Changing to 2.6.22-rc3 as suggested by Marcel however works just fine.
> 

So the latest bug fix to net/bluetooth/rfcomm/tty.c should be applied
to 2.6.21-stable, apparently.
