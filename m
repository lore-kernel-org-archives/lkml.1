Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYDIMRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYDIMRC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 08:17:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYDIMQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 08:16:51 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3565 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYDIMQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 08:16:50 -0400
Date: Wed, 9 Apr 2008 13:16:52 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dirk Eibach <eibach@gdsys.de>, linux-kernel@vger.kernel.org,
       greg@kroah.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: add sysfs configuration interface for CP2101
Message-ID: <20080409121652.GK17915@shadowen.org>
References: <20080229020245.61f1f8f4.akpm@linux-foundation.org> <47C7FB0F.1060902@gdsys.de> <20080229123512.f85f417c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229123512.f85f417c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 12:35:12PM -0800, Andrew Morton wrote:

> > +static int enable_config = false;
> 
> Should be either
> 
> static int enable_config;
> 
> or, if you're being very formal,
> 
> static bool enable_config = false;
> 
> or, if you're being less formal and want to avoid bloating the kernel image,
> 
> static bool enable_config;

I've added detection of false as a 0 value in external and static
contexts; this should be reported in the 0.18:

ERROR: do not initialise statics to 0 or NULL
#1: FILE: Z118.c:1:
+static bool enable_config = false;

-apw
