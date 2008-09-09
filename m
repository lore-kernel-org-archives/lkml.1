Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYIIFQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYIIFQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 01:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYIIFPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 01:15:54 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:32938 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751403AbYIIFPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 01:15:54 -0400
Message-ID: <48C60685.60303@suse.de>
Date: Tue, 09 Sep 2008 09:15:49 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5 acpi: EC Storm error message on bootup
References: <1254.69.2.248.210.1220390835.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <1254.69.2.248.210.1220390835.squirrel@webmail.wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does not disable EC, it disables EC GPE (interrupt from EC).
Could you please test patch from comment #81 in bug #9998?
http://bugzilla.kernel.org/attachment.cgi?id=17695&action=view

Thanks,
Alex.
jmerkey@wolfmountaingroup.com wrote:
> See an ACPI: EC storm detected message, disabling EC
> 
> On both a compaq presario 2200 laptop and an Acer 9410 laptop.  Looks like
> a brain dead error message not actually reporting any genuine errors.
> 
> Jeff
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


