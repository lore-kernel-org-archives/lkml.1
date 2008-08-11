Return-Path: <linux-kernel-owner+w=401wt.eu-S1752305AbYHKLyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbYHKLyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 07:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYHKLx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 07:53:58 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34683 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbYHKLx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 07:53:57 -0400
Date: Mon, 11 Aug 2008 12:53:47 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, S K <nospamnoham@gmail.com>,
       Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Message-ID: <20080811115347.GA25604@srcf.ucam.org>
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com> <200808081430.43012.trenn@suse.de> <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com> <200808092059.47863.trenn@suse.de> <514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com> <1218418431.6671.52.camel@yakui_zhao.sh.intel.com> <514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com> <20080811042244.469f8e1d@infradead.org> <20080811113848.GA8382@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811113848.GA8382@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 03:38:48PM +0400, Alexey Dobriyan wrote:
> On Mon, Aug 11, 2008 at 04:22:44AM -0700, Arjan van de Ven wrote:
> > yeah don't bother with p4-clockmod, it's not something that saves you
> > energy... it only gives you a fake feeling that you would.
> 
> Why it is still in tree?
> 
> It's likely that you'll waste more time explaining everybody to not use
> p4-clockmod than send a patch.

Because it's useful for thermal throttling on hardware that doesn't 
implement voltage scaling.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
