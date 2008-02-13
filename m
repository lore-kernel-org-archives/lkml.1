Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbYBMP5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbYBMP5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932326AbYBMP5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:57:16 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:41374 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbYBMP5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:57:15 -0500
Message-ID: <47B312B3.3010200@panasas.com>
Date: Wed, 13 Feb 2008 17:54:27 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: =?UTF-8?B?U3ZlbiBLw7ZobGVy?= <skoehler@upb.de>,
       Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Joerg Dorchain <joerg@dorchain.net>,
       Jon Chelton <jchelton@ffpglobal.com>,
       Stefan Priebe - allied internet ag 
	<s.priebe@allied-internet.ag>
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>	 <47B1D7A8.8010108@panasas.com>  <47B1DA2A.1060904@panasas.com> <1202917468.3109.5.camel@localhost.localdomain>
In-Reply-To: <1202917468.3109.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13 2008 at 17:44 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Tue, 2008-02-12 at 19:40 +0200, Boaz Harrosh wrote:
>> -	gdth_flush(ha);
>> -
> 
> This piece doesn't look right.  gdth_flush() forces the internal cache
> to disk backing.  If you remove it, you're taking the chance that the
> machine will be powered off without a writeback which can cause data
> corruption.
> 
> James
> 
Yes. 
I have more problems reported, with exit, and am just sending one more patch that puts
this back in. Which was tested.

So I will resend this one plus one new one.

Boaz
