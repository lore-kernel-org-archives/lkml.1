Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbXJLT3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbXJLT3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 15:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbXJLT3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 15:29:46 -0400
Received: from hu-out-0506.google.com ([72.14.214.231]:46369 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbXJLT3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 15:29:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=I8oN1j5UHPNL0c8+yRpAftnB0vsHxsrikoqr8in9CGMlQNiyiiI01fRDynPoU6hzTPjAkSAsGY8unkanxeNEushB2aCMUS29AT6zSqlOeaCj8dbDolykR2+wfb6IT3DOE+9qElFA0A9LPl7S56aCvXYpOx4wb+OVwlTpZ4iuPrM=
Message-ID: <3efb10970710121229q15de054al1cc5828389faff78@mail.gmail.com>
Date: Fri, 12 Oct 2007 21:29:41 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: "John Sigler" <linux.kernel@free.fr>
Subject: Re: halt does not shut the system down
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       robert.moore@intel.com, len.brown@intel.com
In-Reply-To: <470CA1BD.1080502@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <470A58AF.9080402@free.fr> <470B366F.4030306@free.fr>
	 <3efb10970710091304g30ab5549u84a092d4de40368b@mail.gmail.com>
	 <470CA1BD.1080502@free.fr>
X-Google-Sender-Auth: 0f8cb3bcc8e96acb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello John,

> Thanks for the suggestion. I didn't see anything related to SMM in the
> BIOS menus. However, the system has real-time constraints. Thus, I'd
> turn SMM off if I knew how :-)

Here you can find a driver that can disable and enable the SMI
interrupt in the chipset. It supports up to the ICH5 chipsets, but by
adding the proper device/vendor IDs you can also make it support newer
chipsets.
http://www.bohmer.net/smi.tar.bz2

> AFAIU, poweroff is equivalent to halt -p

You are right.

Kind Regards,

Remy
