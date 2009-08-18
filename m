Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbZHRIni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbZHRIni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbZHRInh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:43:37 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:45603 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZHRIng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:43:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bp3LwWRho896VDrmCNc9S0PP8xFWhQ4H0SwCAE5nzafOTpd2CZB3CzXJUQ5Nu861K7
         VcuZlNp3/8fCJFcVQgm4g+gUitMMl06k0NthNzan1l3XHpvqjWeO6he1m+trODwt85An
         8/pyo3IwT+GN/yRVClZ/dvn+O853yV4qxK+5E=
MIME-Version: 1.0
In-Reply-To: <4A89E76B.5070204@dell.com>
References: <4A89E76B.5070204@dell.com>
Date: Tue, 18 Aug 2009 09:43:36 +0100
Message-ID: <9b2b86520908180143t4b25c1f7hd78cd4b4333c4ab4@mail.gmail.com>
Subject: Re: [PATCH 3/3] Drop platform sysfs support
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       cezary.jackiewicz@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/09, Mario Limonciello <mario_limonciello@dell.com> wrote:
> With rfkill support being added, the platform support is no longer
> necessary.  Standard rfkill interfaces can be used to administer the box
> now.
> --
> Mario Limonciello
> *Dell | Linux Engineering*
> mario_limonciello@dell.com
>

-static struct platform_device *compal_device;

I don't think this is the right way to go.  I don't object to removing
the sysfs attributes, but the platform device can still be useful as a
parent device to the rfkill and backlight devices.  (See my earlier
comment on the use of rfkill_allocate()).

In practice I suspect it makes no difference that the rfkill and
backlight devices are exported as virtual devices with no physical
parent.  I just don't think it's "right" :-).

Thanks
Alan
