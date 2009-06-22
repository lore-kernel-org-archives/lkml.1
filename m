Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbZFVOG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbZFVOG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZFVOGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:06:49 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:38606 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZFVOGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:06:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=ceBB0sa5osAcpGXq4rwzvWmz71DgWuACS9uAu69MAvRXi11Ud6QC68ztSD+z4XUs3x
         qhUoJ8I3lkD69LXL4g0SJVjFKO6WevGlFZIztoFvTRHt1jvgjGh5iiV6qki2X1Dgsk/g
         WEMkEbeX8X1Ffy+jrXOIzdfTPo1gp25ESCLCE=
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com
Subject: Re: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
References: <E4D3F24EA6C9E54F817833EAE0D912AC0228288428@bssrvexch01.BS.local>
	<87iqio5txt.fsf@macbook.be.48ers.dk>
	<001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Mon, 22 Jun 2009 16:06:17 +0200
In-Reply-To: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com> (Marek Szyprowski's message of "Mon\, 22 Jun 2009 15\:55\:36 +0200")
Message-ID: <87eitc5pnq.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Marek" == Marek Szyprowski <m.szyprowski@samsung.com> writes:

Hi,

 Marek> Yes, I am aware. That driver does not work well for me (but
 Marek> this is the other case). However I did a test with his driver
 Marek> and the result was also a kernel oops:

Ok :/

Any plans on merging your stuff with Ben's driver?

 >> I've used the g_serial driver on 2.6.29 without problems (not on
 >> s3c6410 though).

 Marek> On what hardware you use the g_serial driver? It is ARM-based?
 Marek> I understand that this might be also related to the way that
 Marek> low level hardware gadget driver is implemented, but I really
 Marek> have no idea how to hunt for this bug.

No, it was on PowerPC (mpc8347).

-- 
Bye, Peter Korsgaard
