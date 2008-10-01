Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYJASzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYJASzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYJASzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:55:38 -0400
Received: from gw.goop.org ([64.81.55.164]:50599 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbYJASzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:55:38 -0400
Message-ID: <48E3C7A2.6010901@goop.org>
Date: Wed, 01 Oct 2008 11:55:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Pavel Machek <pavel@suse.cz>, carbonated beverage <ramune@net-ronin.org>,
       linux-kernel@vger.kernel.org, "Bryan O'Sullivan" <bos@serpentine.com>,
       Karl Czajkowski <karlcz@bbswl.com>
Subject: Re: Thinkpad brightness keys kill X on 2.6.26.5
References: <20080925060244.GA18945@net-ronin.org> <20080930231952.GB15903@ucw.cz> <48E2CB5A.1050809@goop.org> <20081001095322.GA27987@srcf.ucam.org> <48E3C152.1000102@goop.org> <20081001183350.GA3240@srcf.ucam.org>
In-Reply-To: <20081001183350.GA3240@srcf.ucam.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Wed, Oct 01, 2008 at 11:28:34AM -0700, Jeremy Fitzhardinge wrote:
>
>   
>> I'm also using the vesa X server; I haven't tried using the intel one yet.
>>     
>
> Ah. In that case, I suspect the DRM module is never binding and may not 
> do its thing.
>   

OK, great.  Simply loading the i915 module makes the backlight come back 
after resume, even using the vesa X server.

Thanks,
    J
