Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbZCRXBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbZCRXBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 19:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZCRXAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 19:00:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35928 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZCRXAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 19:00:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Li Yang <leoli@freescale.com>
Subject: Re: nonboot cpu on SMP suspend
Date: Thu, 19 Mar 2009 00:00:31 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <2a27d3730903172325w16ec329cp872ec35d100f6506@mail.gmail.com>
In-Reply-To: <2a27d3730903172325w16ec329cp872ec35d100f6506@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903190000.33572.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009, Li Yang wrote:
> Hi all,
> 
> I'm curious why we need to un-plug all the nonboot cpus before suspend
> and start them all over again after the suspend(ACPI sleep)?  I mean
> if we can bring the booting cpu back to the exact state as before
> suspend, why can't we just do the same for non-booting cpus?  And that
> will be much faster.  Any thought?  Thanks.

Because we need to enter the BIOS with one CPU on-line only.

Thanks,
Rafael
