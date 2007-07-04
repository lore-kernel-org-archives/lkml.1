Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbXGDILq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbXGDILq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbXGDILc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:11:32 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:42560 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbXGDILb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:11:31 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 10:11:33 +0200
User-Agent: KMail/1.9.7
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031342.14295.oliver@neukum.org> <18058.55215.185633.434117@cargo.ozlabs.ibm.com>
In-Reply-To: <18058.55215.185633.434117@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707041011.33279.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 4. Juli 2007 schrieb Paul Mackerras:
> Oliver Neukum writes:
> 
> > USB devices certainly have suspend methods.
> 
> Indeed, and the USB framework has code to know when the host
> controller is suspended and avoid trying to send out urbs in that
> case.  Or at least it did last time I looked at it in any detail; it's
> been "just working" - including suspending and resuming, without the
> freezer - for quite a while now.

And what happens to that IO? I suspended and lost data is not an
acceptable behavior.

	Oliver


