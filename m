Return-Path: <linux-kernel-owner+w=401wt.eu-S1762695AbXGCVrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695AbXGCVrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761495AbXGCVrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:47:08 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:36728 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761099AbXGCVrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:47:03 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 23:47:01 +0200
User-Agent: KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20070703211227.GA28758@srcf.ucam.org> <200707032337.52544.rjw@sisk.pl> <20070703213639.GA29149@srcf.ucam.org>
In-Reply-To: <20070703213639.GA29149@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707032347.01936.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieb Matthew Garrett:
> On Tue, Jul 03, 2007 at 11:37:51PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, 3 July 2007 23:20, Matthew Garrett wrote:
> > > We're used to the idea of applications blocking when a resource they're 
> > > using goes away - NFS has done it forever. 
> > 
> > Now, please tell me how many driver writers even thought that something
> > might try to access their devices after .suspend() had been executed (or
> > even whilie it was being executed)?
> 
> Every single driver that fails under those conditions is already broken, 
> and has been forever. It's likely that they're broken under run-time 
> suspend, too.

There _is_ no runtime syspend in working condition. The interface
to do that has been scheduled for removal.

	Oliver

