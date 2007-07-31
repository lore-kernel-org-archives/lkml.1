Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbXGaKlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbXGaKlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbXGaKle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:41:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:2910 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbXGaKld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=jUUtE5drtU3duKlKzk5mv9dEbIS/htc9h0xMf2LoT/oX8lTmwv4MR4JyomTLCPzf9AS8JJSHxXY3ORpAIrHjjrw1LmesXNit6fOjRjp0RXQ+qwp7WoCTVJLkn66gEuJXHw4Zf1TOx5QEi1V8z4gOAUmCi2xB3gYqIiHQJXoGsh0=
Message-ID: <46AF10BF.2090303@googlemail.com>
Date: Tue, 31 Jul 2007 12:36:47 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: "Ph. Marek" <philipp.marek@bmlv.gv.at>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: acpi=off vs. blacklist
References: <200707311235.53302.philipp.marek@bmlv.gv.at>
In-Reply-To: <200707311235.53302.philipp.marek@bmlv.gv.at>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ph. Marek wrote:
[ added linux-acpi to CC ]
> Hello everybody!
> 
> I have two machines which freeze during boot; this seems to be ACPI-related, 
> because with acpi=off they start.
> 
> The first one is the HP DC 7700; some summary can be seen on
>   http://forums1.itrc.hp.com/service/forums/questionanswer.do?threadId=1081719
> It hangs after a line
>   ACPI assume root bridge[\sp_.pci0] bus is 0
> 
> The second one is a notebook; a Roda Rocky III+ RK886EX, which just shows a 
> blank screen.
> 
> As we drive many machines from the same kernel image via PXE, I tried to 
> insert them into drivers/acpi/blacklist.c; but that doesn't help, either - 
> the notebook hangs as before, no matter whether I set is_critical_error or 
> not. 
>  [ I suppose I wrote the entries wrong; is there some HOWTO? I used
>    acpidump/acpixtract/acpitbl, copied other blacklist entries, and took
>    "OEM Table ID", "OEMID", "OEM REVISION". Help? ]
> 
> 
> Using the "ACPI debug" kernel option showed no more messages.
> 
> 
> Help, please? What can/should I do now?
> 
> 
> Regards,
> 
> Phil
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
