Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbYJNJDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbYJNJDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbYJNJDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:03:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:39175 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbYJNJDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:03:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DSaikek9Ih4dqbROnG6ElotdJ51LhwKPUSWZH50p4DW96Q9XjHhTeaD7DtWB0OSxWK
         bFhX0RHw2uM0tWjF2gtIPy/IqbCO5O+TZ7nOj39M3e4KBEQzpRCvVPEsp7hQ3YE+DIYb
         x1sXKtvNQtggeLfDYcBlg6KbESqrReQLI5jjw=
Message-ID: <48F46053.6070306@gmail.com>
Date: Tue, 14 Oct 2008 13:03:15 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alan Jenkins <aj504@student.cs.york.ac.uk>
CC: Pavel Machek <pavel@suse.cz>, Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Robert Goldner <robert@au-79.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>, linux-stable@vger.kernel.org
Subject: Re: Patch needed for ASUS EEEPC 701 2.6.27 (perhaps a regession)
References: <48F0BD2D.8000001@tuffmail.co.uk> <20081013203648.GA3260@ucw.cz> <48F45D52.2010407@tuffmail.co.uk>
In-Reply-To: <48F45D52.2010407@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> It could be a coincidence. But it's suspicious enough to advise 
> caution. We know what the bug is, and we have a very nice workaround 
> queued up now. There's no reason to test any more of these specific 
> systems to destruction :).
> I did try re-installing off the vendor DVD and it was still broken.  I fear I bought it from the wrong place to get sympathetic _frontline_ support / warrantee.  I'm not interested in RMA back to Asus - too much work and downtime for a cheap system, when I have an easy workaround.  I haven't noticed any problems with "noapic".
>
>
> The symptoms strongly suggest overflow in an event buffer or counter maintained by the Embedded Controller.  So the EC firmware may have a bug, of the sort that results in "unspecified behaviour".  A bug in a special purpose (read: not subject to wide testing) subsystem which has direct connections to things like frequency and voltage control.
>
> Hopefully I'm wrong, and I don't really know what I'm talking about here.
>
> Regards
> Alan
>   
Did you try to disconnect all power resources (e.g. AC adapter and all 
batteries and wait for some time)?
May be there are some default settings in the BIOS?
This looks small enough to be a HW failure...

Regards,
Alex.

