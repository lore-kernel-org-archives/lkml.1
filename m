Return-Path: <linux-kernel-owner+w=401wt.eu-S1763148AbXJEPPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763148AbXJEPPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbXJEPPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:15:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46828 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274AbXJEPPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:15:11 -0400
Message-ID: <470654D4.3020304@zytor.com>
Date: Fri, 05 Oct 2007 08:14:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, jikos@jikos.cz,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: video resume stuff
References: <20071004130513.GA16076@elf.ucw.cz> <470511A9.4060705@zytor.com> <20071005073238.GA19065@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20071005073238.GA19065@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> I guess major change is to rename conflicting symbols, so that it is
> possible to link it twice. That would mean boot_memset() instead of
> memset() etc... Is that acceptable?
> 

Messy, but I guess we can deal with it.  One can always do it with 
#define lest it gets too ugly.

	-hpa
