Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbZFRWoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbZFRWoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758330AbZFRWo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:44:28 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:56554 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329AbZFRWo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oPwyPpF61OwAPMgTpzpBbLkLRccF6e0NyfOjkDzSTI7N0BUqJ1r7erdG6duCh0Oay8
         1OGeUEcytgcyFgzjE/6YfSXZuC06ogj7UlvITXUUO91Gb0VCp/nsnF2ZzZNhc86DwGU0
         FBe/ZleifbBmJn8REGmMdznNJGb/9nheIwhwc=
MIME-Version: 1.0
In-Reply-To: <9b2b86520906180633i2bc2ad6bk20c43d8426798b18@mail.gmail.com>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>
	 <9b2b86520906131051t32183554r8208cf886609e09c@mail.gmail.com>
	 <71cd59b00906141226k37b90b9ey7347ed85ec17a17b@mail.gmail.com>
	 <61b223ba0906150109r3a69e98aq949c7f2df5563c6e@mail.gmail.com>
	 <15e53e180906160133j7055536cqe5b9515704fd4d94@mail.gmail.com>
	 <4A375914.5050800@tuffmail.co.uk>
	 <15e53e180906160147w1fa6282dl50e8e728f067e090@mail.gmail.com>
	 <71cd59b00906160244t21bc0553tc8e209c70497687d@mail.gmail.com>
	 <15e53e180906160304u37f8c702m808ece710359ef9a@mail.gmail.com>
	 <9b2b86520906180633i2bc2ad6bk20c43d8426798b18@mail.gmail.com>
Date: Fri, 19 Jun 2009 00:44:28 +0200
Message-ID: <71cd59b00906181544j4fa957b1n6dcd3bdf34efc423@mail.gmail.com>
Subject: Re: [gpm] [PATCH 2.6.29] eeepc-laptop: report brightness control 
	events via the input layer
From: Corentin Chary <corentin.chary@gmail.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Richard Hughes <hughsient@gmail.com>, gnome-power-manager-list@gnome.org,
       acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 3:33 PM, Alan
Jenkins<sourcejedi.lkml@googlemail.com> wrote:
> On 6/16/09, Richard Hughes <hughsient@gmail.com> wrote:
>> On Tue, Jun 16, 2009 at 10:44 AM, Corentin
>> Chary<corentin.chary@gmail.com> wrote:
>>> Ok, so we just need to patch this file :
>>> http://cgit.freedesktop.org/hal-info/tree/fdi/information/10freedesktop/10-laptop-panel-hardware.fdi
>>
>> Yes
>>
>>> But I'm not sure how to do it to make it works on all Eeepc.
>>
>> Well, really we want to match "classes of eeepc", so matching with
>> prefix might be a good idea.
>>
>> Richard.
>
> Yes please!  I see the 701 is (just added?) on the list, but this

The 701 was already here when I checked.

> But I hope there's a nicer solution.  Corentin, do you think it would
> be correct to apply this quirk to _all_ Asus laptops?

I can confirm that all the asus laptop I know change the brightness in the
firmware. So, in my opinion, we can safely apply this quirk to all Asus laptops.


-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
