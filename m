Return-Path: <linux-kernel-owner+w=401wt.eu-S1760546AbXETQjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546AbXETQjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 12:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758482AbXETQjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 12:39:14 -0400
Received: from smtp-out.google.com ([216.239.45.13]:44532 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279AbXETQjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 12:39:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=n5DjmiktUkvFipjG4Jx/D65LsjlfomCIF8p42FLv6UblDvAqB9IV84mw2Au70UtMR
	k7nEkffCXleVPlQqKzXIg==
Date: Sun, 20 May 2007 09:38:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Extract common MODULE_INFO content into new
 moduleinfo.h.
In-Reply-To: <Pine.LNX.4.64.0705200627220.6765@localhost.localdomain>
Message-ID: <alpine.DEB.0.99.0705200934580.30819@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705200354380.3319@localhost.localdomain>
 <alpine.DEB.0.99.0705200142080.25601@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705200627220.6765@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Robert P. J. Day wrote:

> i can do that as long as there's no way that those changes can (even
> theoretically) make a difference in the build.  in order to make sure
> this patch didn't break anything, i went with a straight cut-and-paste
> of the content to go into the new moduleinfo.h.
> 

__attribute_used__ is pointless outside of function definitions so the way 
it is currently written is incorrect.

> so while i agree that those changes shouldn't hurt, personally, i'd
> prefer to just put this patch through as is and come back later to do
> any tidying related to attribute rewording.
> 

__attribute_used__ is deprecated so it would be helpful to change it now 
instead of requiring a second patch.  It's better if new patches no longer 
use a deprecated attribute.
