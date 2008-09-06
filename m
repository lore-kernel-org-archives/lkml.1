Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbYIFQfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbYIFQfL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 12:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYIFQe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 12:34:58 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:46540 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbYIFQe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 12:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Y5ORzLepO/dVDwXfSYUfNzRocKfhNFS3vXrrHz3aBAh4h3WuUsMFTxvUvGReyUDWb0
         HAASYOn/uRelcecT/CP2b1iVQ1E7jdkvf2w5S3gwEJIHZOiH6oNkHVmq2syEuBe12YRe
         /owKgGAUJJaV5ljIJGWz6tIMS2hNRqi//VF9A=
Message-ID: <8ee0b8e80809060934y385c1fefhd614befccbf64869@mail.gmail.com>
Date: Sat, 6 Sep 2008 18:34:56 +0200
From: "Jeroen van Rijn" <jvrnix@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Cc: "Willy Tarreau" <w@1wt.eu>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       pageexec@freemail.hu, "Andi Kleen" <andi@firstfloor.org>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
In-Reply-To: <20080906154551.GB1774@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080903195122.73905236@infradead.org>
	 <48C0FF43.30940.2C3EFC0@pageexec.freemail.hu>
	 <1220609647.4879.169.camel@pasglop>
	 <48C10EC5.24400.3008276@pageexec.freemail.hu>
	 <1220612231.4879.175.camel@pasglop> <20080905114233.GA27878@elte.hu>
	 <20080905204134.GI19337@1wt.eu> <20080906154551.GB1774@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> a reboot often raises attention. But yes, in terms of end user boxes,
> probably not. Anyway, my points were about transparent rootkits
> installed on a running system without anyone noticing - obviously if the
> attacker can modify the kernel image and the user does not mind a reboot
> it's game over.
>

Hi,

can't then, in this scenario, the VFS keep tabs on /boot/vmlinuz and
only allow modification when the process in question properly
authenticates itself. As long as we're talking signed modules, why not
lock certain files down as well?

e.g. hand the kernel a signed list of files to watch write access to,
and allow only after the process auths via a private key.

-- Jeroen.

n.b. I understand this would slow down things more, but if we're
talking about taking extreme measures...
