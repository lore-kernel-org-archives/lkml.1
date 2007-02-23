Return-Path: <linux-kernel-owner+w=401wt.eu-S933192AbXBWTLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192AbXBWTLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 14:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933189AbXBWTLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 14:11:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:62734 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933185AbXBWTLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 14:11:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EUlioF3ysvOxfzzSQ2OTZOCvpeFkMUZS9OpRFwkiRrhhsKCu/T9sb1zL0u+hE/oT4rhdhOzEnerES4x0R+lhdWuX/OEUcXueCXIPxNTGhP8o86hCWKJka3ARV0RS2NHgsg2IXsbI9zIxvUQxout8wXdJkNHX5YmVpUXxuTqU5hU=
Message-ID: <e9c3a7c20702231111l1cb8767ar7f670c5e3c2338b4@mail.gmail.com>
Date: Fri, 23 Feb 2007 12:11:44 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.20: stripe_cache_size goes boom with 32mb
Cc: "Jason Rainforest" <l3mming@iinet.net.au>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0702230741540.3781@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702230640430.3781@p34.internal.lan>
	 <1172234460.4419.7.camel@merlin>
	 <Pine.LNX.4.64.0702230741540.3781@p34.internal.lan>
X-Google-Sender-Auth: 50994f43d33b766d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> I have 2GB On this machine.  For me, 8192 seems to be the sweet spot, I
> will probably keep it at 8mb.
>
Just a note stripe_cache_size = 8192 = 192MB with six disks.

The calculation is:
stripe_cache_size * num_disks * PAGE_SIZE = stripe_cache_size_bytes

--
Dan
