Return-Path: <linux-kernel-owner+w=401wt.eu-S934212AbYCSXrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212AbYCSXrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934894AbYCSWOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:14:39 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:51297 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbYCSWOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:14:37 -0400
To: Jeff Dike <jdike@addtoit.com>
Cc: user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@timesys.com>
Subject: Re: [2.6.24.x] UML select()/poll() oversleeping reproducibly
References: <47B34BA0.30006@club-internet.fr>
	<20080214003853.GA15952@c2.user-mode-linux.org>
	<47B4BDCD.4080605@club-internet.fr>
	<20080215160205.GA6082@c2.user-mode-linux.org>
	<47B5CE40.9000005@club-internet.fr>
	<20080215184650.GA8810@c2.user-mode-linux.org>
	<87y78kx640.fsf_-_@hades.wkstn.nix>
	<20080317193415.GA12234@c2.user-mode-linux.org>
	<87k5k112kf.fsf@hades.wkstn.nix>
	<20080318170019.GA8747@c2.user-mode-linux.org>
From: Nix <nix@esperi.org.uk>
Emacs: ... it's not just a way of life, it's a text editor!
Date: Wed, 19 Mar 2008 22:14:14 +0000
In-Reply-To: <20080318170019.GA8747@c2.user-mode-linux.org> (Jeff Dike's message of "Tue, 18 Mar 2008 13:00:19 -0400")
Message-ID: <87od9apdjd.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-INFN-TO-Metrics: hades 1233; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 Mar 2008, Jeff Dike told this:
> This version keeps track of the time between ticks (as reported by the
> host's gettimeofday) and adjusts its sleeping and reporting ticks
> accordingly.

I can confirm that, as expected, this patch works well enough that
timing problems don't break dhclient anymore (which requires a 2x
oversleep, which you're a long way from now).

At last I can upgrade my firewall :)

-- 
`The rest is a tale of post and counter-post.' --- Ian Rawlings
                                                   describes USENET
