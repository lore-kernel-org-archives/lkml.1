Return-Path: <linux-kernel-owner+w=401wt.eu-S1762459AbYBWTjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762459AbYBWTjn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761716AbYBWTjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:39:31 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51488 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761654AbYBWTj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:39:29 -0500
Date: Sat, 23 Feb 2008 20:39:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Simon Richter <sjr@debian.org>, Tilman Schmidt <tilman@imap.cc>,
       Jeff Garzik <jeff@garzik.org>, kkeil@suse.de, Greg KH <greg@kroah.com>,
       Gregory Nietsky <gregory@networksentry.co.za>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
Message-ID: <20080223193939.GA15591@uranus.ravnborg.org>
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org> <47BAA072.9050601@networksentry.co.za> <47BC370F.3000705@imap.cc> <47BD5360.5070706@debian.org> <20080222120412.GA11916@pingi.kke.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222120412.GA11916@pingi.kke.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karsten.

> Normally I reserved the complete last week for working on mISDN to get it
> ready to submit it to -mm, but reality did hit me and I had to do some
> other importent stuff :-(

When you do your first submission can you please submit the minimal
possible configuration.
I tried enabling the AVM!Fritz and I could see that with this
driver alone the following files got build:

avm_fritz.c layer3.c l3_udss1.c capi.c contr.c listen.c appl.c
plci.c app_plci.c ncci.c
asn1.c asn1_aoc.c asn1_comp.c asn1_generic.c asn1_diversion.c asn1_basic_service.c asn1_address.c asn1_enc.c
capi_enc.c supp_serv.c core.c stack.c udevice.c helper.c debug.c fsm.c channel.c l3helper.c sysfs_obj.c
sysfs_inst.c sysfs_st.c dtmf.c isac.c arcofi.c
layer1.c layer2.c tei.c
x25_dte.c x25_l3.c

And that a *lot* to review in one go.
So if you could squeze that down to less files it would be nice.

And only one simple HW drivers (I randomly selected avm_fritz above).
When we get this in shape you can follow up with more HW drivers.

Thanks,
	Sam

