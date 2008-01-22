Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbYAVBSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbYAVBSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 20:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbYAVBSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 20:18:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:10673 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYAVBSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:18:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bo6TNj2wGHdP+SomZo+dAEfSuEz8MAli0YCKGNd0JGiZFRW5a8fGoDDrZ5gOVWALUnW2cmyJrGbDshYvbUtFEv9cXUYdxcjxgMVGAANCJKCPZPfQObFwWqKJHaSkBJggJl7sJydWsmjNkfQJE0ChXfnLMX4Ur4nPRw3AXQZ30Tk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: ATA device reset, shoud I be concerned?
Date: Tue, 22 Jan 2008 02:31:22 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Georgi Chulkov <g.chulkov@jacobs-university.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Mark Lord <liml@rtr.ca>
References: <200801140019.20668.g.chulkov@jacobs-university.de> <20080121164744.2f7d0ed1@lxorguk.ukuu.org.uk> <4794D020.4060204@gmail.com>
In-Reply-To: <4794D020.4060204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801220231.22609.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2008, Tejun Heo wrote:

[...]

> > Old IDE says it works for PATA. For SATA I can see it might need more
> > care and you might simply not be able to get the info.
> 
> Old IDE often locks up the machine hard after timeouts.  I'm all for

Could you point me to some bugreports?

I would like to know more about hosts/conditions for which it happens.

> gathering more info but benefit vs. risk equation just doesn't look good
> here.  Why take risk for a rare device which forgets to raise IRQ on
> media error?  If such behavior is wide spread among PATA drives && we
> can verify that TF register access after timeout is safe for PATA
> controllers, sure, but currently we aren't sure about either.

Thanks,
Bart
