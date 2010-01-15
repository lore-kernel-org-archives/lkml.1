Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841Ab0AOAPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab0AOAPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563Ab0AOAPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:15:12 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:35158 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab0AOAPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:15:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PBomvTZCmdqAge1IjM7LgOyfVIPyOXiDmQo15E+Ghm56GuivWwfierSXQHL92TtltC
         NVlthsRF8YBXaXJWzOaI/pxOWOvoCDcRogUOmOG4WJr8rufNXATfBBPlZM6bOxIyci1T
         peqKxNjRJg75Hke/wqgJR1/HBQD7+YBj0/8RQ=
MIME-Version: 1.0
In-Reply-To: <m3iqb4iwb4.fsf@intrepid.localdomain>
References: <201001121700.18234.seth.heasley@intel.com>
	 <4B4D4EAA.2010109@gmail.com> <4B4DAA68.60608@pobox.com>
	 <m3my0i6nou.fsf@intrepid.localdomain> <4B4DFE1A.4000606@pobox.com>
	 <m3iqb57ts7.fsf@intrepid.localdomain>
	 <51f3faa71001131557n52e34260k13bf1fe3057bb0e@mail.gmail.com>
	 <m3iqb4iwb4.fsf@intrepid.localdomain>
Date: Thu, 14 Jan 2010 18:15:08 -0600
Message-ID: <51f3faa71001141615n5776454cwbf6787b7a7fb0081@mail.gmail.com>
Subject: Re: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel 
	Cougar Point DeviceIDs
From: Robert Hancock <hancockrwd@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jeff Garzik <jgarzik@pobox.com>, Seth Heasley <seth.heasley@intel.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 8:40 AM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> Robert Hancock <hancockrwd@gmail.com> writes:
>
>> The behavior here is strange, the controller reports a connection
>> status change interrupt with CommWake which should indicate that some
>> device completed the handshake with the controller, but then the SATA
>> link shows down. I assume there's nothing plugged into the two JMicron
>> SATA ports?
>
> Precisely nothing. Only the PATA is connected.

It would be interesting to see what happens if you actually plug
something into that port that's having the issues, and see what
happens. I'm kind of inclined to suspect it's a hardware fault, though
it would likely require a report from someone else with the same or
similar board model to confirm that..
