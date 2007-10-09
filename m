Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbXJIUCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbXJIUCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 16:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbXJIUCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 16:02:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:13075 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbXJIUCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 16:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EbBUqeU90Pfg4CrLSMdJ/vZHAyzjaRu5JLyMgbhGYCQpdDgT30ACjIIV7bvTJeqm6SK+5/uYjz1PzkADDkmXcZ3La2vRExrBAQQ0xbmE3FgUxGn+TvUisbrjpQptT+3BDrZaISvOSKDT2egS5WDDWjrXZRR06wu8/c7jXfOSQHw=
Message-ID: <d120d5000710091301h790db3c4nc44e71551a4bc408@mail.gmail.com>
Date: Tue, 9 Oct 2007 16:01:58 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Arjan Opmeer" <arjan@opmeer.net>
Subject: Re: First stab at Elantech touchpad driver for 2.6.22.6. Testers wanted!
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <20070914000015.GA20527@adopmeer.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070914000015.GA20527@adopmeer.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On 9/13/07, Arjan Opmeer <arjan@opmeer.net> wrote:
>
> Hi!,
>
> This is a first stab at a Linux driver for the Elantech touchpad as found on
> some laptops (e.g. MSI MS-1035 aka L725).
>

This is great! Thank you very much for your effort.

Since the touchpad supports absolute mode I'd recommend removing
support for extended relative mode and concentrating on making
absolute mode work so that Synaptics X driver can be used with this
touchpad as well.

-- 
Dmitry
