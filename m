Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbYJXVo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbYJXVo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 17:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757062AbYJXVoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 17:44:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48210 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007AbYJXVoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 17:44:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: 2.6.27-rc8-git8: oops in process hald-addon-dell-backlight (intel iommu related?)
Date: Fri, 24 Oct 2008 23:49:02 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <pan.2008.10.08.20.15.37@telenet.be> <pan.2008.10.08.20.41.23@telenet.be>
In-Reply-To: <pan.2008.10.08.20.41.23@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810242349.02738.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 8 of October 2008, Frederik Himpe wrote:
> On Wed, 08 Oct 2008 20:15:37 +0000, Frederik Himpe wrote:
> 
> > On my Dell Latitude E6400 system with Intel chipset and graphics, I get
> > this oops in my 2.6.27-rc8-git8 based kernel, which probably happens
> > when hald-addon-dell-backlight is started.
> > 
> > Complete dmesg and lspci info:
> > https://qa.mandriva.com/show_bug.cgi?id=44711
> 
> Booting with intel_iommu=off seems to fix this issue, and seems to make my 
> e1000e based network card stop from giving "transmit timed out" errors 
> after which it stopped working.

Is it necessary to boot 2.6.27 final on this box with intel_iommu=off, and if
so, is it still necessary in mainline?

Rafael



