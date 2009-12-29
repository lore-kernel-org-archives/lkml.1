Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbZL2Ph3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbZL2Ph3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZL2PhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:37:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:13356 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbZL2PhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:37:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ob8RNMAN0hTGRuvdh+QI6six2DzqrosnaD2Jnorg+oJqwrIr9qnS5HgaRV4lUW7Klz
         Uxfn7CO/7YO+dbe+Hdc0SCMg8ocVORM/+T4YKto5CtEZ3IHPl6t8nOQlouZ/mmnR6fWD
         8wJUrzqfxhdRlM0qHSDTJdYBAxtpOcmlC4bIo=
MIME-Version: 1.0
In-Reply-To: <NJVdobuNFNK.A.90H.anhOLB@chimera>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
	 <NJVdobuNFNK.A.90H.anhOLB@chimera>
Date: Tue, 29 Dec 2009 17:37:18 +0200
X-Google-Sender-Auth: ea7bf2e3067643e6
Message-ID: <84144f020912290737y695f6e41xe599decf1c68c50e@mail.gmail.com>
Subject: Re: [Bug #14904] slab: possible recursive locking detected
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 5:09 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14904
> Subject         : slab: possible recursive locking detected
> Submitter       : Heiko Carstens <heiko.carstens@de.ibm.com>
> Date            : 2009-12-18 11:58 (12 days old)
> References      : http://marc.info/?l=linux-kernel&m=126113754023909&w=4
> Handled-By      : Pekka Enberg <penberg@cs.helsinki.fi>

This is the same problem as the following:

http://bugzilla.kernel.org/show_bug.cgi?id=14951
