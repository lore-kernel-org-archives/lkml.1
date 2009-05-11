Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbZEKObo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbZEKObo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbZEKObf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:31:35 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:6975 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZEKObe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:31:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Gz/IVZiWEEJZxvLCZAFDAPzHRgjjQHhowDBAhL2/n38vxLAbGt0y1bP0YqTJVfdBKQ
         XGlQPmMbJ5/VP+c72XHRx0thC++XClrGmVGid+tacNwaUbaZSNgG7z+IwEz6Y2a3H5tz
         YGX0G2Hqm9AJkY9gQ8m0un2BvJf4WJcjIy/Q8=
Message-ID: <4A0836CA.5070709@gmail.com>
Date: Mon, 11 May 2009 16:31:38 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.7 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       e1000-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [E1000-devel] e1000: "eeprom checksum is not valid" after kexec
References: <49F06EEB.9060500@gmail.com> <49F0D22E.6050101@gmail.com> <20090423211754.GD4017@vespa.holoscopio.com> <200904241809.45240.rjw@sisk.pl>
In-Reply-To: <200904241809.45240.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2009 06:09 PM, Rafael J. Wysocki wrote:
> My understanding is that the commit pointed to by Jiri caused a problem
> if the current mainline kernel was kexeced from an older kernel (2.6.27.x from
> openSUSE-11.1 in this particular case), because the older kernel didn't
> have the recent network driver fixes applied.  Is this correct?

Exactly!

> Also, I'm still interested in whether or not removig the following three lines:
> 
>         /* Check if we're already there */
>         if (dev->current_state == state)
>                 return 0;
> 
> from pci_set_power_state() in the current mainline kernel fixes the problem
> in the configuration where it is readily reproducible.

After removing those lines, the problem still persists:
e1000: 0000:02:01.0: e1000_probe: The EEPROM Checksum Is Not Valid



