Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbYKDP6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbYKDP6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbYKDP5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:57:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:32858 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbYKDP5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:57:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=DSx176Y/SlqD3R3DATg4O6OVkB4PYGV9esoNa2Wi6K1+9SZ7HE1HcQofYvPYXo18Nc
         rA/pcDZ622qlc5yofW4/ezKFPJKPagq6bV1kq89esbh7EvC3xuuD/84wTynqE5IPxC4u
         UqU8OBParmMgX8EkF2/0ETxHlur59ebRzEuzE=
Message-ID: <491070EC.4030309@tuffmail.co.uk>
Date: Tue, 04 Nov 2008 15:57:32 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4
References: <20081102040008.GB29606@khazad-dum.debian.net>	<490D8C4E.3010201@tuffmail.co.uk>	<20081102130655.GA12766@srcf.ucam.org>	<20081103141628.GB31078@khazad-dum.debian.net>	<20081103141836.GA31894@srcf.ucam.org>	<490F0ACC.4000808@tuffmail.co.uk>	<20081103145145.GD31078@khazad-dum.debian.net>	<20081103145543.GA496@srcf.ucam.org>	<20081103150229.GF31078@khazad-dum.debian.net>	<20081103150843.GA1107@srcf.ucam.org>	<20081103163311.GA2417@khazad-dum.debian.net> <20081104134832.6c596d54@doriath.conectiva>
In-Reply-To: <20081104134832.6c596d54@doriath.conectiva>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luiz Fernando N. Capitulino wrote:
> Em Mon, 3 Nov 2008 14:33:11 -0200
> Henrique de Moraes Holschuh <hmh@hmh.eng.br> escreveu:
>
> | On Mon, 03 Nov 2008, Matthew Garrett wrote:
> | > On Mon, Nov 03, 2008 at 01:02:29PM -0200, Henrique de Moraes Holschuh wrote:
> | > > Right now, you should still rfkill_force_state().  Please wait for an hour
> | > > or two while I clean up that broken resume handling, and I will tell you for
> | > > sure.
> | > 
> | > Cool. I'll hold off posting my cleanups until then in that case.
> | 
> | Ok, two bugs reproduced, the fixes are ready and tested, and I will be
> | sending it now to linux-wireless.  You're in the CC, so you will get them.
> | 
> | I will also need to send patches for -stable, as the ones for mainline won't
> | apply to -stable.
>
>  Great.
>
>  Do the patches have anything to do with the problem I have reported?
>   

No.  These patches don't affect what happens when the rfkill device is
unregistered.

>  Rafael has opened a bugzilla ticket for it:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=11928
>   


