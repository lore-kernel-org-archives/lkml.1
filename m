Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbZDDSCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbZDDSCV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 14:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbZDDSCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 14:02:12 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:32329 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753574AbZDDSCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 14:02:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RUmxzw917fXiRLoQi7BZqL5bS2mp/rD7fbgPWPRPbNnv6jv+R107czLDncPwJM/fAwrBq1i3etQvCxS+VR2kBJtPIIjLm9D0GGBgMORuMpms7PE4VIadfBeUmP4Gmi3bcBsQAlXGFQQxwFpDzfgOc5rLmQW+OQsV7Pb9Ywm9duk=  ;
X-YMail-OSG: jnDQadYVM1kPn9iNg8VQyoMmSvW5_1S_WpmV3z6ySBgQ_G.gC924FEZ24fF_6FXNgVzays1UKnOqZCDTheW9htdSnUgtnXnQitd5trSj5GiKEH5QpkH7yiHIpmXKLXs.UuTTR3sr2NpkSfoSVS48BIsArJpI3J40u6S5N1nFkfVxCHksUY4noNlkP4F38CQiKIPgskoTeuU3tKJHVBrlLcea8oz3B2VfaGjJXid_0bVeoLh5ASM9LoR3z9euUTuzJTvlTcyiDhIQsvkA
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] fix RTC-CMOS message, now with SOB
Date: Sat, 4 Apr 2009 11:02:07 -0700
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>
References: <m3vdpnvvzt.fsf@intrepid.localdomain> <m3r60bvvrg.fsf@intrepid.localdomain>
In-Reply-To: <m3r60bvvrg.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904041102.07751.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 April 2009, Krzysztof Halasa wrote:
> +               !is_valid_irq(rtc_irq) ? "no alarms" :
> +               cmos_rtc.mon_alrm ? "alarms up to one year" :
> +               cmos_rtc.day_alrm ? "alarms up to one month" :
> +               "alarms up to one day",

Could you reformat that so it looks more like the compound-IF
statement it really is?  That is, display the nesting structure.
And not use negative logic for that first test.

