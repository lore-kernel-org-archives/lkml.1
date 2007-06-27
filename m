Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbXF0GkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbXF0GkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 02:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbXF0Gj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 02:39:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:8861 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbXF0Gj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 02:39:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l1OvXRgDhcM2bAS8un79dknCMRZIMOFbu3leGAW15CBpXzE+TOXCYVM7iP1i31M1hEs5FsNMQmeWtRVamToPmMhHi1/OVf9UweCwgQGkjAVsH5X7yenj/sCpulVbZHZsBSkevv6ihXIfGuDHPWJ0qhwFBPsC1nvuUIxrX1DcD6Y=
Message-ID: <a781481a0706262339w4c92e295s62a6c041dd1e9666@mail.gmail.com>
Date: Wed, 27 Jun 2007 12:09:55 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [md-accel PATCH 03/19] xor: make 'xor_blocks' a library routine for use with async_tx
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de,
       akpm@linux-foundation.org, davem@davemloft.net,
       christopher.leech@intel.com, shannon.nelson@intel.com,
       herbert@gondor.apana.org.au, jeff@garzik.org
In-Reply-To: <20070627015049.18962.54083.stgit@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
	 <20070627015049.18962.54083.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

[ Minor thing ... ]

On 6/27/07, Dan Williams <dan.j.williams@intel.com> wrote:
> The async_tx api tries to use a dma engine for an operation, but will fall
> back to an optimized software routine otherwise.  Xor support is
> implemented using the raid5 xor routines.  For organizational purposes this
> routine is moved to a common area.

This isn't quite crypto code and isn't connected to or through the cryptoapi
(at least not in this patchset), so I somehow find it misplaced in the crypto/
directory. If all its users are in drivers/md/ then that would be a
better place.
If it is something kernel-global, lib/ sounds more appropriate?

Satyam
