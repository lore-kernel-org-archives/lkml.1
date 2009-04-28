Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbZD1KEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbZD1KEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbZD1KEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:04:22 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:35331 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbZD1KEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:04:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GaxD1yaDIyHmJOpt4L45X/ubuUU2Wgr6wbJykzv79YOA7GVX9E7wj7D3wU8F9n+tMB
         X7+PP74fbapRj9QRu2461w4oLywytN1MXpghLsX+1v1CC90HgAPd1cZI0khuBugejwtw
         Fn0arbyNjxnKkrzSnRKN7wzzhEfXOVNISMpy4=
Subject: Re: [PATCH] Acer Aspire One Fan Control
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: petkovbb@gmail.com
Cc: Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
       lenb@kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <20090428072519.GA12170@liondog.tnic>
References: <cone.1240623959.159615.9486.1000@mentalhome>
	 <cone.1240648971.372002.7492.1000@mentalhome>
	 <20090426172947.GB3643@liondog.tnic>
	 <cone.1240858632.795110.5316.1000@onepiie>
	 <20090428072519.GA12170@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Apr 2009 13:04:15 +0300
Message-Id: <1240913055.29860.14.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 09:25 +0200, Borislav Petkov wrote:
> Hi Peter,
> 
> On Mon, Apr 27, 2009 at 08:57:12PM +0200, Peter Feuerer wrote:
> > Hi Boris,
> >
> > thank you very much for your email.
> >
> > Borislav Petkov writes:
> >
> >> I did some testing on my Aspire One machine here and it looks pretty
> >> nice: while compiling a kernel watched the fan going on when the
> >> temperature reaches 67-68 (I don't think this is Celsius though, no?)
> >> and then turning itself off when temp goes below 60.
> >
> > It is Celsius, the specification of the chipset and the atom core say 
> > that the chips are allowed to get 99 degree celsuis hot. So I think 70 
> > degree Celsius are fine.
> 
> Their N270 datasheet
> (http://download.intel.com/design/processor/datashts/320032.pdf) talks
> about max Tj (junction temperature) being 90°C for a TDP of 2.5W and if
> you operate below that limit "functionality and long-term reliability
> can be expected." :)
> 
> There's also an internal termtrip sensor which is designed to go off at
> Tj=125°C so, yeah, I guess something 70°C should be ok.

I have small note:

So yes cpu can withstand 90 C, but will rest of the motherboard?

(Most other cpus are rated at 60C)


Regards,
	Maxim Levitsky

