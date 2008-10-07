Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbYJGMH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbYJGMH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 08:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYJGMHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 08:07:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:58905 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbYJGMHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 08:07:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jL7irldhxr/h4FO77L0d2+b45adYbZU5jAmPWd0pvRAthWVJCrgNdJFC1ByMQxciD4
         rI4kP17aRPh4fJozfGEH4Q8YTqTswBX9ZP6AWBZ5JxtxTD1iBDhAgiqiSB8D5wkvJ2Dc
         8rOH0jZcTLiTHbCbGhkXua4gYzfAvLqLU+duw=
Message-ID: <f7848160810070507n1a75034dta6fb97880174d22a@mail.gmail.com>
Date: Tue, 7 Oct 2008 08:07:49 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: 2.6.27-rc8+ - first impressions
Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081007113747.GA2819@amd.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081005183603.GA3263@amd.corenet.prv>
	 <20081005121046.579089b9@infradead.org>
	 <20081006062838.GC2808@amd.corenet.prv>
	 <20081006195350.GB22097@alberich.amd.com>
	 <20081007034230.GA6095@amd.corenet.prv>
	 <20081007091032.GD22097@alberich.amd.com>
	 <20081007113747.GA2819@amd.corenet.prv>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2008 at 7:37 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hmm, that unfortunately does not work because I have SB4X0 revision 0x11
> and the patch cuts off everything below 0x82. Is there anything that can
> be done to enable HPET on early revisions?
>

Later BIOS revisions for the 6115 "enable Vista support" which
actually means HPET is properly enabled in BIOS for Vista to work.
(i.e. there won't be a need to force enable it with later BIOS versions.)

Any reason you could not try the BIOS upgrade I pointed out earlier?

Parag
