Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbZD0TI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbZD0TI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759964AbZD0THk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:07:40 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36669 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759946AbZD0THj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:07:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=b3v5NE1wvQOkMoKMwyJbAZ80edX7666lgQKWDJuLcJg7eOJ13zFcFr0ZuiwDSwRdKq
         7+Q+m4/PsJMJ5CqSDY/1nb8ihO/rN6+HSirbwvdxKc9bGp1K5Gh5Kvdk3CQonUdWn6Pm
         Gu8IQ4pFch3ASQPLj6+I69jp9i5d+fnlgzmX0=
Subject: Re: [Sdhci-devel] SDHCI driver runnining in aspire one, allows to
 write to R/O SD cards
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Garrett D'Amore" <garrett@damore.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, pierre@ossman.eu,
       sdhci-devel@lists.ossman.eu,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <49F5F57D.3010700@damore.org>
References: <1240219764.13640.5.camel@maxim-laptop>
	 <49ED0865.9030603@gmail.com>  <1240524632.20871.0.camel@maxim-laptop>
	 <1240759276.10972.0.camel@maxim-laptop>  <49F5F57D.3010700@damore.org>
Content-Type: text/plain
Date: Mon, 27 Apr 2009 22:07:34 +0300
Message-Id: <1240859254.11237.8.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-27 at 11:12 -0700, Garrett D'Amore wrote:
> As an extra data point, my sdhost driver in OpenSolaris works fine on 
> the AA1.. it does see that the cards are locked, and refuses to allow 
> them to be mounted read/write.
> 
> This leads me to believe that the original linux problem is one of two 
> things:
> 
> * either a bug in the linux code, or
> * busted circuit/hardware on a specific unit (i.e. a damaged unit)
> 
> I believe that if the Linux code was buggy here, the problem would be 
> reproducible on all platforms, not just the AA1.  So my inclination, 
> barring independent confirmation, is that most likely there are one ore 
> more defective units out there.
> 
> Note that the AA1 also has buggy BIOS -- OpenSolaris can't "see" the 
> cards (registers aren't properly initialized) unless they are present 
> when the unit first powers up.

But, why it works in windows?

Regards,
	Maxim Levitsky

