Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbZEMG2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbZEMG2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 02:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZEMG1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 02:27:49 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:37603 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbZEMG1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 02:27:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ec27V2h9akLLTWY5S1llrcGzY9f2iGEEIVkp+gQLv9BpY4jbL2oaXCyTv1z4u/UpIs
         HNVGG/eRVVRkge8bOjDLv2sRQ3mr5WuNeYdpgJlYWc0Ft+/fNaVux8fDfo4mAbcgKVhb
         5Cqr4fEZa+Y5xIoTqiSVczwhvm/D6AVm+mBh4=
Message-ID: <4A0A6862.3020809@googlemail.com>
Date: Wed, 13 May 2009 08:27:46 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Michael Buesch <mb@bu3sch.de>,
       David Dillow <dave@thedillows.org>, Rui Santos <rsantos@grupopie.com>,
       =?ISO-8859-15?Q?Michael_B=FCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
References: <200903041828.49972.m.bueker@berlin.de> <4A06D8D2.4010505@googlemail.com> <1242001754.4093.12.camel@obelisk.thedillows.org> <200905112248.44868.mb@bu3sch.de> <m3eiuufufj.fsf@intrepid.localdomain> <4A09EE13.3020102@googlemail.com> <20090513061138.GA11106@electric-eye.fr.zoreil.com>
In-Reply-To: <20090513061138.GA11106@electric-eye.fr.zoreil.com>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Francois Romieu wrote:
> Michael Riepe <michael.riepe@googlemail.com> :
> [...]
> 
>>How do lspci and dmesg report the chip? For mine, lspci says it's a
>>"RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)" while
>>the kernel reports "RTL8168c/8111c at 0xffffc200000f6000,
>>00:1c:c0:b6:1a:4a, XID 3c4000c0".
> 
> 
> The XID is more specific than the first kernel report. lspci is less
> accurate.

Then the question is: Are there two different revisions with the same
XID, or is it always the same chip that sometimes works and sometimes
doesn't?

I can't remember anybody reporting that the Intel D945GCLF2 works for
them, so it might also be an interoperability issue.

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
