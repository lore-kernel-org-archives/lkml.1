Return-Path: <linux-kernel-owner+w=401wt.eu-S934152AbXHJSIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152AbXHJSIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 14:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbXHJSIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 14:08:38 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:27879 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbXHJSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 14:08:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cBUsCUKx4oM9K3vdYyegrrPVFGGZC9CBzKG5/gd7Km0loZS/x4tR8XpeVShqn+h93hsTwDUrdV6aKClhFeb5dclvyj7ZFWAAjwZygMIjnGhTec+eR7bc3WTAzXuPRqWayMHXuo/OJii4wz7zdHwd4gO+L1l6toj26IL99g8MLNs=
Message-ID: <5d6222a80708101108y62ebfa26n9f47bfc52b48f4a8@mail.gmail.com>
Date: Fri, 10 Aug 2007 15:08:35 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 23/25] [PATCH] paravirt hooks for arch initialization
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       anthony@codemonkey.ws, Steven@smtp2.linux-foundation.org,
       akpm@linux-foundation.org,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       virtualization@lists.linux-foundation.org, mingo@elte.hu
In-Reply-To: <20070809190303.214e5457@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <11865468394005-git-send-email-gcosta@redhat.com>
	 <11865468431616-git-send-email-gcosta@redhat.com>
	 <200708081144.04119.ak@suse.de> <46BB5258.8040609@goop.org>
	 <20070809190303.214e5457@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > What's the EBDA actually used for?  The only place which seems to use
> > ebda_addr is in the e820 code to avoid that area as RAM.
>
> It belongs to the firmware.

Wouldn't it be better, then, to just skip this step unconditionally if
we are running a paravirtualized guest? What do we from doing it?

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
