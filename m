Return-Path: <linux-kernel-owner+w=401wt.eu-S1762867AbYFKQIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762867AbYFKQIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 12:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760830AbYFKQIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 12:08:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:10072 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762763AbYFKQIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 12:08:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=s3CvS94FGqhNK7OMe3QOf9oU1EpIu9yR1U7xACcYrfiO0mjqeAe8OPVYDv1oVIWhB5
         jlACCblPBnSPjFzhXOk3QysPOhYgrm7jEjsXxgm7GKjyHklrpn2E4glT4n5lMyDsPTDa
         zJzGZpUzB6LYjRLH/tMDhSOoVhY4rIj24LDOw=
Message-ID: <2c0942db0806110908i7d99b47ej155ae11d6d832077@mail.gmail.com>
Date: Wed, 11 Jun 2008 09:08:40 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080611063639.5e1eea5b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806102152.23286.solstice.dhiver@gmail.com>
	 <20080610131314.5f7069e6@infradead.org> <484EE71A.40002@intel.com>
	 <alpine.LNX.1.10.0806111440480.20733@fbirervta.pbzchgretzou.qr>
	 <20080611063639.5e1eea5b@infradead.org>
X-Google-Sender-Auth: ff19fc852058cb9d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 6:36 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> CPU frequency is...
> 1) not something that is fixed; it changes all the time

Not necessarily true of setups where jackd is running.

> 2) not a good indication for performance; remember the 3.4Ghz pentium4,
> a 2Ghz Core2Duo outperforms it

Your point only holds if jackd is somehow using this to compare
performance across different cpus. It's not.

> 3) something which the cpu itself barely honors (the clock stops during
> idle etc etc)

Again, that won't be happening when jackd is running.

> Userland apps that use "cpu frequency" seem to be buggy to me, at
> least I don't believe that they understand the complexities about what
> this means,

It doesn't appear you understand what jackd is and what lengths users
will go to to configure their systems for running it smoothly and
reliably.

> and I don't believe that the decisions they make based on
> this will be made correctly.

Please go read the jackd designs slides from the 2003 presentation on
the jack website [1]. The author has a clue, and is quite aware of how
computers work.

   [1] http://lad.linuxaudio.org/events/2003_zkm/slides/paul_davis-jack/title.html
