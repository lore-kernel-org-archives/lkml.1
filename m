Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbYIBMvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbYIBMvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 08:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYIBMva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 08:51:30 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:20388 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYIBMv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 08:51:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TH5kP/lzpOEUBB6iiMkdVf5cp5gEtzJ8NEaA2lbnYl9lX08BkcT9AhgVYTbC74JWXn
         3gYJtPK9XnvZGus/9hrcBOncgsM1CgnLoFhHgZwiHz7Sux/ep9uywMQgareWJKgaz5FU
         yPax9HYIlrXQebgdovcqHGB3W26e9wC5VUaEk=
Date: Tue, 2 Sep 2008 08:51:12 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jiri Kosina <jkosina@suse.cz>, Daniel Barkalow <barkalow@iabervon.org>,
       linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
Message-ID: <20080902084801.ZZRA012@mailhub.coreip.homeip.net>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz> <20080902124313.GA24358@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080902124313.GA24358@khazad-dum.debian.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 09:43:13AM -0300, Henrique de Moraes Holschuh wrote:
> On Tue, 02 Sep 2008, Jiri Kosina wrote:
> > so the product name both of System and Base Board are different, and 
> > apparently the systems differ. Dmitry, what fields would you propose to be 
> > put in the DMI matching here? I will do the patch then.
> 
> Are you sure you shouldn't be looking at BIOS version, instead?

Unfortunately we can't do "less than" type of comparison on DMI data,
otherwise it would be great solution.

> I don't know
> how the Lenovo N100 series is, but chances are their i8042 is emulated
> inside the ACPI EC, i.e. a firmware upgrade can change the i8042 behaviour.
>

I think this is true for all boxes manufactured in the last 8 years.

> I'd check BIOS versions, and ask people to upgrade to the latest, to see if
> the problem goes away (or changes).  Then you will know for sure the best
> approach.
>

Keeping compatibility with the other OS is the safest way so unless
Vista started using active MUX there is probably update to the BIOS
fixing legacy mux mode.

-- 
Dmitry
