Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbYIVJXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbYIVJXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 05:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYIVJX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 05:23:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:10118 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYIVJX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 05:23:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Ui2KsG0FH31gNxDQcYp00MM5/FiEE/gz4FInJbmulPIYEH4ueetcymWTA1/penxOmn
         uekdXDEBidbBlQYGjaXRfMo9qTYLmYZ51z3sdXUxU55PARDHABlUHsiXzvyTf0MxeW0V
         t/nrQCp8JFLEgyJiVdeL4MnOBFGunXP7pbGZ4=
Message-ID: <84144f020809220223jbb71877ued9d3b2569c4cd67@mail.gmail.com>
Date: Mon, 22 Sep 2008 12:23:25 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: [RFC] List of maintainers (draft #3)
Cc: "Uwe Kleine-K?nig" <ukleinek@strlen.de>,
       "Denis Vlasenko" <vda@port.imtp.ilyichevsk.odessa.ua>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080922091256.GH1916@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200202071054.g17Asst06608@Port.imtp.ilyichevsk.odessa.ua>
	 <20080922081239.GA28726@strlen.de>
	 <20080922091256.GH1916@fluff.org.uk>
X-Google-Sender-Auth: 0437a08f2c64eab2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 22, 2008 at 12:12 PM, Ben Dooks <ben-linux@fluff.org> wrote:
> I was thinking of at least making MAINTAINERS per-subsystem, it is a
> large file and would be easier for the people submitting patcehs to
> avoid having to touch a common file.

Figuring out whom to send a patch to is not something you can automate
because it not only depends on what you're changing but *how* you're
changing it. The classic case being that whenever you change something
related to RCU that's non-trivial, you almost certainly want to CC
Paul "RCU" McKenney. But there's no *file* or *directory* pattern that
can automatically tell you this.

Furthermore, if you're hacking on a specific part of the kernel, you
almost certainly are doing it wrong if you don't know who the relevant
maintainers are. For simple janitorial patches, you probably should
just work out the *top-level* maintainers (davem for networking, ingo
et al for x86, and so on) and send the patches to them. And when these
simple rules fail you, fall back to patch bombing Andrew.

                             Pekka
