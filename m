Return-Path: <linux-kernel-owner+w=401wt.eu-S1760970AbXGDLD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970AbXGDLD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757577AbXGDLDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:03:01 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:33495 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518AbXGDLDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:03:00 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 13:02:58 +0200
User-Agent: KMail/1.9.7
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <20070703042916.GA17240@srcf.ucam.org> <200707041253.33154.oliver@neukum.org> <18059.32169.906914.258802@cargo.ozlabs.ibm.com>
In-Reply-To: <18059.32169.906914.258802@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041303.00016.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 4. Juli 2007 schrieb Paul Mackerras:
> Oliver Neukum writes:
> 
> > They can't. Device specific protocols are known to the drivers only.
> > The fact remains, remove the freezer and you need to go through
> > all drivers.
> 
> The freezer does not actually mean that you don't have to get the
> drivers right, because kernel threads can issue I/O requests.

Kernel threads do not issue requests for the hell of it. And yes,
kernel threads must be aware of suspension. Threads are few,
drivers many.

	Oliver
