Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZANGj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZANGj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 01:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbZANGjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 01:39:16 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:55376 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbZANGjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 01:39:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vUXLXABdp5dpKpH1DOPvQJjLvRwxDfIQDodcpykRXM7Iy0VzHd3JoSxpFkOVFPA5Ab
         F3BVnNJFF2+PFtMwdhrvs5S0ItfTzRNX7Kr+zV++HRVh5YLuq0XyBxvEJN9dHD2GOepm
         mrL/dFhXAc7bxemh9Km2FldA00FPkAK9O2j7w=
Date: Wed, 14 Jan 2009 06:39:09 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Chris Caputo <ccaputo@alt.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Badalian Vyacheslav <slavon@bigtelecom.ru>,
       Denys Fedoryschenko <denys@visp.net.lb>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: deadlocks if use htb
Message-ID: <20090114063909.GA4234@ff.dom.local>
References: <20081010090426.GA6054@ff.dom.local> <20081010095129.GB6054@ff.dom.local> <48F6FB3E.7060903@bigtelecom.ru> <20081016084027.GA17632@ff.dom.local> <48FEC302.5090707@bigtelecom.ru> <20081022070200.GB4178@ff.dom.local> <493FDCD4.5020108@bigtelecom.ru> <20081218081737.GA8416@ff.dom.local> <Pine.LNX.4.64.0901110438050.16453@nacho.alt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901110438050.16453@nacho.alt.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 02:43:13AM +0000, Chris Caputo wrote:
...
> Per Jarek's suggestion in bugzilla, I ran 2.6.28 plus Peter Zijlstra's 
> "hrtimer: removing all ur callback modes" patches dated 2008-11-25, 
> 2008-12-04 and 2008-12-08.  Uptime was 2 days 22 hours before I hit what 
> appears to be an unrelated bug related to the IPv6 FIB.  (Separately 
> reported with subject 'panic with 2.6.28 while doing "ip -6 route"'.)

Chris, this is a very good news, thanks for testing this!

Peter, great work! IMHO these patches should go to the stable (at
least 2.6.28).

Thanks,
Jarek P.
