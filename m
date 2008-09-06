Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbYIFFnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbYIFFnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 01:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYIFFni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 01:43:38 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:3273 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYIFFni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 01:43:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c5GMGW2b4ZURfVzMtDHR7tqjps9ABkaiIWpx6HAI7xQnMZvWUk+SdZCk34P3oXCuRN
         TE726zCa7SX1pDPI4v5LDmrj9PGM3uLSdz7egnYB42L+npdFSGgcRXRjHziD/0M3CYGz
         P7Zq8fG68HKdRS6Xn4RWdI/7LzjZdtGXSbz+Q=
Date: Sat, 6 Sep 2008 09:45:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: kobject leak in next-20080829 (and mainline)
Message-ID: <20080906054522.GA3191@x200.localdomain>
References: <20080830044246.GA26435@x200.localdomain> <20080830054343.GA16899@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080830054343.GA16899@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 10:43:43PM -0700, Greg KH wrote:
> On Sat, Aug 30, 2008 at 08:42:46AM +0400, Alexey Dobriyan wrote:
> > 	size-32: 3511 kvasprintf+0x57/0x90
> > 	size-64: 3059 kobject_create+0x1c/0x40
> > 
> > These two buddies increase after every "modprobe; rmmod" sequence.
> 
> Do they also do so in mainline?

Yep, same bug in mainline.

