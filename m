Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbYHKLii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbYHKLii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 07:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYHKLi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 07:38:29 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:54090 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbYHKLi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 07:38:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pbGNNhGJCvUky0hXau/TBYlIPWhkHzTyj0oQwyQhLhUcTyISnYxZe7xZoTLpAIYr0J
         3ZAtDRJRi2ElyLHNQE0kIiHENTmT94l/I0Ph7ou0Ov64qmKQ2YT4o3Hh+P2bO8m3g5DF
         3n4Sk/NhZk0xsabqbKFaNKO+SnRiTvszK6yvo=
Date: Mon, 11 Aug 2008 15:38:48 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: S K <nospamnoham@gmail.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Message-ID: <20080811113848.GA8382@martell.zuzino.mipt.ru>
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com> <200808081430.43012.trenn@suse.de> <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com> <200808092059.47863.trenn@suse.de> <514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com> <1218418431.6671.52.camel@yakui_zhao.sh.intel.com> <514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com> <20080811042244.469f8e1d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811042244.469f8e1d@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 04:22:44AM -0700, Arjan van de Ven wrote:
> On Sun, 10 Aug 2008 21:44:50 -0700
> "S K" <nospamnoham@gmail.com> wrote:
> > > But it is very strange that cpufreq scaling can work on Windows XP.
> > > Will you please try the P4 clock cpufreq driver and see whether the
> > > scaling can work ? In fact P4 clock cpufreq driver is already
> > > replaced by acpi_cpufreq driver for the latest cpu.
> > > Anyway please try p4 clock cpufreq driver.
> > 
> > What is the name of the driver? I'm not able to find any such driver
> > in Fedora 9 installed modules. There is only acpi-cpufreq and
> > powernow-k8.
> > 
> 
> yeah don't bother with p4-clockmod, it's not something that saves you
> energy... it only gives you a fake feeling that you would.

Why it is still in tree?

It's likely that you'll waste more time explaining everybody to not use
p4-clockmod than send a patch.

