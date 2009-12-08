Return-Path: <linux-kernel-owner+w=401wt.eu-S966364AbZLHVal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966364AbZLHVal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966255AbZLHVaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:30:35 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:57733 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966216AbZLHVad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:30:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jYWpKDoMcpqcohQtw9iGtkT7RUqJVY5Upa/C/XFpMUpKAqu2eq0A8gCDskkTZZFeGM
         SzyHWRzqnagJMJfZ+eD1lHLE7xVGe3l+7fa30wEu/CD0uoOy1uERw5dVctmh5R8gLzX4
         DGMWNxbc+xVgAVMVTXyChLIu/ICQUbotYbORo=
MIME-Version: 1.0
In-Reply-To: <20091208155103.GA27118@srcf.ucam.org>
References: <4B192D08.9080608@gmail.com>
	 <9b2b86520912080205x478b47eek2377dacdbe44a522@mail.gmail.com>
	 <20091208125530.GA23520@srcf.ucam.org> <4B1E7481.6020902@gmail.com>
	 <20091208154738.GC26435@srcf.ucam.org> <4B1E75AE.5050901@gmail.com>
	 <20091208155103.GA27118@srcf.ucam.org>
Date: Tue, 8 Dec 2009 21:30:39 +0000
Message-ID: <9b2b86520912081330s18b692d5me712dba0fa9b4c82@mail.gmail.com>
Subject: Re: [PATCH] Toshiba Bluetooth enabler (rfkill)
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jes Sorensen <jes.sorensen@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lenb@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/8/09, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Dec 08, 2009 at 04:50:06PM +0100, Jes Sorensen wrote:
>
>> Understand, not sure how to go about this. It doesn't seem to generate
>> an APIC event on off, it just pulls the USB device out of it's plug. Not
>> sure if it would be possible to plug into the USB unplug event?
>
> In principle, I guess, but I don't think there's a great deal of
> advantage in it.

Agreed.  I think the rfkill device would be a nice-to-have for
troubleshooting, but nothing more.  If you can't implement it using
ACPI events alone, it seems less useful for troubleshooting anyway.

Regards
Alan
