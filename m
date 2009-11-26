Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbZKZCKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbZKZCKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 21:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbZKZCKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 21:10:41 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:40110 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZKZCKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 21:10:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GDUuStVHljyd48ivvHlXJbgixrWr2MS+K6Pq7XexoTQLlYL5CpE/w9BdOleHGKyKkP
         MXY8Yi2xTOAMIy6E5A57jknrgnvzDxJrW9EVR/mn/eVTkAoMrBxdQcUZwur4jndtmrS4
         U+8BmfIu5ZVKg+HCEXMr57qMiqpqQzvZF7cas=
Date: Wed, 25 Nov 2009 18:10:40 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-input@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: ads7846 touchscreen: fix pressure
Message-ID: <20091126021040.GA23079@core.coreip.homeip.net>
References: <20091120182238.GA1344@ucw.cz> <20091120182528.GB16447@core.coreip.homeip.net> <20091120185058.GA1472@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120185058.GA1472@ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 07:50:58PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > On Zaurus, pressure is reported inverted -- the lighter the pressure,
> > > the bigger numerical value. This should fix it.
> > > 
> > 
> > Thanks. Didn't you also have a bigger cleanup patch for ads7846?
> 
> Yes, I did, but I wanted to avoid risk for collision. So pick one...
> 

Thanks. I ended up picking both...

-- 
Dmitry
