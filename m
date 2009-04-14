Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbZDNX7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbZDNX7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 19:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZDNX7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 19:59:38 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:64910 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZDNX7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 19:59:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=u2+2TDplTcBtWiNlOlOYysTw5w8BJvl2x6qahIxPQNe4W4K88PfmYFg+1rLd/u29VE
         gI6DYrNv9F80dfrYgjBd5lY3hqx1s/YifbJH3uRFxyKHBsX4YuHtIy3QeU3ZXygDyjlc
         F9ip4rhjiGbLh9B+idg1JQfJ7awVcF8IzpPfY=
Message-ID: <49E5234E.5070303@gmail.com>
Date: Wed, 15 Apr 2009 01:59:10 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, mjg59@srcf.ucam.org
CC: yakui_zhao <yakui.zhao@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control brightness
 with hotkeys (BISECTED)
References: <49E10684.5090101@gmail.com> <20090411150555.8b13ed18.akpm@linux-foundation.org> <20090412161448.GC26502@khazad-dum.debian.net> <49E234ED.5010105@gmail.com> <1239585695.5564.5.camel@localhost.localdomain> <49E3575A.60204@gmail.com> <20090413203450.GC16152@khazad-dum.debian.net>
In-Reply-To: <20090413203450.GC16152@khazad-dum.debian.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2009 10:34 PM, Henrique de Moraes Holschuh wrote:
> On Mon, 13 Apr 2009, Niel Lambrechts wrote:
>   
>>>> In 2.6.29.1:
>>>> lrwxrwxrwx 1 root root 0 Apr 12 20:01 /sys/class/backlight/acpi_video0
>>>> -> ../../devices/virtual/backlight/acpi_video0
>>>>         
>
> Well, that at least confirms that thinkpad-acpi doesn't have anything to
> do with your troubles, you were using acpi video.
>   

Okay, I've bisected it to:

74a365b3f354fafc537efa5867deb7a9fadbfe27 is first bad commit
commit 74a365b3f354fafc537efa5867deb7a9fadbfe27
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Thu Mar 19 21:35:39 2009 +0000

    ACPI: Populate DIDL before registering ACPI video device on Intel

---

Matthew, can you help?

Regards,
Niel
