Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbZG0QBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbZG0QBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZG0QBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:01:05 -0400
Received: from mail-yx0-f198.google.com ([209.85.210.198]:53758 "EHLO
	mail-yx0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZG0QBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=l5dn4o7F2MyyzGhezuRT6pOhkGlw6ZK8h38ZroDlltcEFaq586HLWzb+PUfFQ3aBKD
         U5ZXCsb94NEumdAvI1FmJ2b8vbDhRukT7AM7jd2CwcB5okwiB8Bwm+Tp01Ihf8gfQlvz
         vyuaj0Tm8L9Th2o2PSXCejCsSGwlvzeoE3R8c=
MIME-Version: 1.0
In-Reply-To: <20090727140039.GC13577@bo.mcbone.net>
References: <1248681637.7279.12.camel@fnki-nb00130> <1248694266.6987.1594.camel@twins> 
	<1248697004.7279.31.camel@fnki-nb00130> <1248697409.6987.1617.camel@twins> 
	<1248698755.7279.47.camel@fnki-nb00130> <1248701812.6987.1637.camel@twins> 
	<20090727140039.GC13577@bo.mcbone.net>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Mon, 27 Jul 2009 09:00:44 -0700
X-Google-Sender-Auth: dca328c39fc74be7
Message-ID: <2c0942db0907270900uef8f32ao72319090d816d3c4@mail.gmail.com>
Subject: Re: futexes: Still infinite loop in get_futex_key() in 2.6.31-rc4
To: Jens Rosenboom <jens.rosenboom@freenet.ag>
Cc: Peter Zijlstra <peterz@infradead.org>, Sonny Rao <sonnyrao@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 7:00 AM, Jens Rosenboom
<jens.rosenboom@freenet.ag> wrote:
>
> On Mon, Jul 27, 2009 at 03:36:52PM +0200, Peter Zijlstra wrote:
> > On Mon, 2009-07-27 at 14:45 +0200, Jens Rosenboom wrote:
> >
> > > Good question, but as this happens on a production machine, I cannot
> > > easily change the installation to check this.
> >
> > Uhm, but you do run .31-rc4 on it? :-)
>
> In the hope of verifying a patch, yes. Before that we had 2.6.29.4
> for some time.

In principle you should be able to run an x86_64 kernel on that
machine with the 32-bit userspace unchanged. The only hassle would be
if you are using any kernel modules outside the normal tree. So, no
need to change the full installation.
