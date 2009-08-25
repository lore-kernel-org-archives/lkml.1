Return-Path: <linux-kernel-owner+w=401wt.eu-S932338AbZHYXHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbZHYXHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbZHYXHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:07:53 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:55901 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932322AbZHYXHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:07:52 -0400
Date: Wed, 26 Aug 2009 01:11:38 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: David Dillow <dave@thedillows.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Riepe <michael.riepe@googlemail.com>,
       Michael Buesch <mb@bu3sch.de>, Rui Santos <rsantos@grupopie.com>,
       Michael B?ker <m.bueker@berlin.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.30-rc4] r8169: avoid losing MSI interrupts
Message-ID: <20090825231138.GB13630@electric-eye.fr.zoreil.com>
References: <m1skfkrik2.fsf@fess.ebiederm.org> <1250895567.23419.1.camel@obelisk.thedillows.org> <1250897657.23419.5.camel@obelisk.thedillows.org> <m1iqggf4rf.fsf@fess.ebiederm.org> <m18whcf3w2.fsf@fess.ebiederm.org> <1250973787.3582.14.camel@obelisk.thedillows.org> <m1r5v0ogvw.fsf@fess.ebiederm.org> <1251169150.4023.11.camel@obelisk.thedillows.org> <m1ljl77exz.fsf@fess.ebiederm.org> <1251237296.9607.42.camel@lap75545.ornl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251237296.9607.42.camel@lap75545.ornl.gov>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Dillow <dave@thedillows.org> :
[...]
> I wouldn't object if you did it, but I don't have time for it right now.
> And it may make Francois's life harder when he does his periodic sweep
> of the vendor driver, looking for differences.

This part of Realtek's driver(s) is not too tricky (I wonder if some code is
there by design or accident but it is a different story).

I do not feel safe with the TxDescUnavail bit : the driver does not
explicitely do anything to handle it but the behavior of the driver
can change depending on it. :o/

-- 
Ueimor
