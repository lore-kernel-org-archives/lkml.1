Return-Path: <linux-kernel-owner+w=401wt.eu-S1765619AbXHFRgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765619AbXHFRgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758862AbXHFRg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:36:26 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:44718 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbXHFRgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:36:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GjOcarmr2I8iHHTRaVmY35xC3Bz98Fk9UuMDnAq9Z55Q5IP6aRXt7FA5ETXxHDXUIeQE0rZ3cSSkXC6LLmdHrS/mS2ABt7xcw9oVHX9pmWBVn0bNEDtkqRlg2P8xok+C5zVMQde86Q/PBFR8PSeJ2J59WX++Y7Euvdy/H73YCWw=
Message-ID: <46B75C0E.8010007@gmail.com>
Date: Tue, 07 Aug 2007 02:36:14 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: Daniel J Blueman <daniel.blueman@gmail.com>, Mark Lord <lkml@rtr.ca>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ICH8 CF timeout (regression)...
References: <6278d2220708020348k26ac2293v648442f2281eca70@mail.gmail.com>	<46B20D6B.1060506@gmail.com>	<6278d2220708021411q17cdc151p79922e5dab74add4@mail.gmail.com>	<46B25DE1.4050105@rtr.ca>	<6278d2220708030322h2c779fa3o1e2e2d9c83ff62e8@mail.gmail.com>	<46B30651.9030505@gmail.com>	<6278d2220708031538s4a57f126ybfa0486816de4401@mail.gmail.com>	<46B41706.4080008@gmail.com> <20070806102836.ea157fed.kristen.c.accardi@intel.com>
In-Reply-To: <20070806102836.ea157fed.kristen.c.accardi@intel.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> In the data sheet in section 5.15.2.3 it describes a value of map.mv of
> 1 as meaning that the SATA controller is emulating the logical secondary
> channel, and the PATA channel will be the primary.  For a value of
> map.mv == 2, we have the SATA controller being primary, and the PATA
> is secondary.  So, if I'm understanding the way ata_piix does mapping, 
> it seems like for a value of 2, we should have [p0, p2, ide, ide] and 
> for a value of 1 we should have [ide, ide, p0, p2] - although for ICH8M 
> it seems like 1 should not be a valid value. My reading the ICH8 spec is 
> that ICH8M only implements a map value of 2, and 1 should be reserved 
> (see section 12.1.33).

Alright, thanks a lot.

-- 
tejun
