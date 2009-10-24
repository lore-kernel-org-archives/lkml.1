Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbZJXVQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbZJXVQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 17:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZJXVQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 17:16:45 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:38538 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbZJXVQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 17:16:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dm4R5M71JPt+q1D/wrcMukP0cZS0gUWSE7FobwHCRwfOMFlKr35VPdhvyQT8PILixY
         JrqisTwn1akmKaS3az7oLm/pnMjiAomIOnXhhrgmpO2KQTTw95GaeMaW7O6aAF0ohYGm
         w+NnlzKloiYfuu738u+D5oYPNn53dwhgHCBcA=
Date: Sat, 24 Oct 2009 14:10:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Harald Dunkel <harald.dunkel@t-online.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.4, ps2-to-usb adapter: fourth mouse button not working
Message-ID: <20091024211045.GB15297@core.coreip.homeip.net>
References: <1N1EA3-10pOoy0@fwd05.aul.t-online.de> <20091023073730.GB10914@srcf.ucam.org> <4AE2C572.1030209@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE2C572.1030209@t-online.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harald,

On Sat, Oct 24, 2009 at 11:14:26AM +0200, Harald Dunkel wrote:
> On 10/23/09 09:37, Matthew Garrett wrote:
>> Sorry, just noticed that you said it was an active one. Does it generate
>> wheel events for any other PS/2 mice? It may simply be a limitation of
>> the hardware.
>>
>
> Using a regular mouse with 3 buttons and a wheel there is no problem.
> All work fine. But it just got 3 buttons. I've got problems with a
> fourth button, so the PS/2 mouse doesn't show.
>
> Is there a hardwired limit to 3 buttons somewhere in the code?

No, but the 4th button of your TackMan requires Logitech's PS/2++
protocol extension which your USB converter is not likely to support.

I believe most of them speak bare, Intellimouse and Expolorer PS/2
protocols...

-- 
Dmitry
