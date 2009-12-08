Return-Path: <linux-kernel-owner+w=401wt.eu-S932239AbZLHPtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbZLHPtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbZLHPtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:49:40 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:65172 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbZLHPtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:49:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZpXZwY8d4o1emJX24SPH1arnzeXzP433OlBiwnaP2pMR84J2MRaLxRZTFQocAuFh9e
         xPUIuxFpSWNDJWPV3A75387MqFnr9QXowdT9zaQwKJ0fdXQsChP0ctg5MFEO8WbhkAQQ
         MEWpQYp6OvjSk8NoxBfCkqjKTdFUgGcoMnDVc=
Message-ID: <4B1E75AE.5050901@gmail.com>
Date: Tue, 08 Dec 2009 16:50:06 +0100
From: Jes Sorensen <jes.sorensen@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Alan Jenkins <sourcejedi.lkml@googlemail.com>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lenb@kernel.org
Subject: Re: [PATCH] Toshiba Bluetooth enabler (rfkill)
References: <4B192D08.9080608@gmail.com> <9b2b86520912080205x478b47eek2377dacdbe44a522@mail.gmail.com> <20091208125530.GA23520@srcf.ucam.org> <4B1E7481.6020902@gmail.com> <20091208154738.GC26435@srcf.ucam.org>
In-Reply-To: <20091208154738.GC26435@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/09 16:47, Matthew Garrett wrote:
> On Tue, Dec 08, 2009 at 04:45:05PM +0100, Jes Sorensen wrote:
>> I believe I can call into BTST and determine whether the switch is set
>> to on or not. It's quite easy to add this to the resume handler and only
>> call if it's set to on.
>
> Right, but in normal use it's an issue. Unless we get notifications for
> both types of state change, we can't add an rfkill device.
>

Understand, not sure how to go about this. It doesn't seem to generate
an APIC event on off, it just pulls the USB device out of it's plug. Not
sure if it would be possible to plug into the USB unplug event?

Cheers,
Jes

