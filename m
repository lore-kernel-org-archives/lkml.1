Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZD1URr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZD1URr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbZD1URi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:17:38 -0400
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:33039 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbZD1URi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:17:38 -0400
References: <cone.1240623959.159615.9486.1000@mentalhome> <cone.1240648971.372002.7492.1000@mentalhome> <20090426172947.GB3643@liondog.tnic> <cone.1240858632.795110.5316.1000@onepiie> <20090428072519.GA12170@liondog.tnic> <1240913055.29860.14.camel@maxim-laptop>
Message-ID: <cone.1240949852.549814.7466.1000@mentalhome>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: petkovbb@gmail.com, LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Date: Tue, 28 Apr 2009 22:17:32 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxim,

>> Their N270 datasheet
>> (http://download.intel.com/design/processor/datashts/320032.pdf) talks
>> about max Tj (junction temperature) being 90°C for a TDP of 2.5W and if
>> you operate below that limit "functionality and long-term reliability
>> can be expected." :)
>> 
>> There's also an internal termtrip sensor which is designed to go off at
>> Tj=125°C so, yeah, I guess something 70°C should be ok.
> 
> I have small note:
> 
> So yes cpu can withstand 90 C, but will rest of the motherboard?
> 
> (Most other cpus are rated at 60C)

That's why the module is started in "user mode" where the bios controls the 
fan. - The Bios just starts the fan as soon as the temperature is higher 
than 40 degree celsius.

The user must explicitely start "kernel mode" to make the kernel 
controlling the fan. Maybe we should add a warning somewhere, that it could 
harm the hardware?

regards,
--peter
