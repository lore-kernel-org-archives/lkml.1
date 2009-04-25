Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbZDYRvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbZDYRvk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 13:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZDYRvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 13:51:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbZDYRvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 13:51:31 -0400
Date: Sat, 25 Apr 2009 10:48:26 -0700
From: Greg KH <gregkh@suse.de>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: staging indentation & braces disagreement list
Message-ID: <20090425174826.GA26972@suse.de>
References: <Pine.LNX.4.64.0904251221060.22716@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0904251221060.22716@wrl-59.cs.helsinki.fi>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 12:28:06PM +0300, Ilpo Järvinen wrote:
> Hi,
> 
> Below is a list from my braces vs indentation pipeline against  
> staging (mainline 0c8454f56623)... Plenty of add-bracing/reindentation 
> required but I'm busy elsewhere so I leave it up to somebody who wants
> to eyeball the code to see which of the alternatives is the
> right one. Please disregard the line numbers, they don't match
> with the source because the source was trimmed beforehand.

I wouldn't worry about the majority of these, they are getting replaced
with "real" wireless drivers soon :)

> drivers/staging/frontier/tranzport.c
> 183
> 	if (dev->offline == 2 && dev->interrupt_in_buffer[1] == 0xff)
> 		goto resubmit;
> 		if (dev->offline == 1 && dev->interrupt_in_buffer[1] == 0xff) {
> 			dev->offline = 2;


this is probably a bug :(

thanks,

greg k-h
