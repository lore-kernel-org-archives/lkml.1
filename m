Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbZFPJvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbZFPJvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZFPJvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:51:25 -0400
Received: from mail-fx0-f211.google.com ([209.85.220.211]:50598 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZFPJvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:51:24 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2009 05:51:23 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qKBzSK6ibeycCfsFKWgugkfZOketTQCBkX+HOluABDBP8L3KSArH/OWSiMOAVAEX/T
         AMAjo6+++B4gj2Cy3+70bvA/qmYeOjkwTKkmureWgagxn90fNj90aNvZc0bpN4mTvIIX
         L7iWS1HnMzcuS18kcz7OpLkrjzh+IZxlzXvhA=
MIME-Version: 1.0
In-Reply-To: <15e53e180906160147w1fa6282dl50e8e728f067e090@mail.gmail.com>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>
	 <4A337251.7010705@tuffmail.co.uk>
	 <71cd59b00906130306w319c0fc2i376bb03323845b80@mail.gmail.com>
	 <507032D758%linux@youmustbejoking.demon.co.uk>
	 <9b2b86520906131051t32183554r8208cf886609e09c@mail.gmail.com>
	 <71cd59b00906141226k37b90b9ey7347ed85ec17a17b@mail.gmail.com>
	 <61b223ba0906150109r3a69e98aq949c7f2df5563c6e@mail.gmail.com>
	 <15e53e180906160133j7055536cqe5b9515704fd4d94@mail.gmail.com>
	 <4A375914.5050800@tuffmail.co.uk>
	 <15e53e180906160147w1fa6282dl50e8e728f067e090@mail.gmail.com>
Date: Tue, 16 Jun 2009 11:44:58 +0200
Message-ID: <71cd59b00906160244t21bc0553tc8e209c70497687d@mail.gmail.com>
Subject: Re: [gpm] [PATCH 2.6.29] eeepc-laptop: report brightness control 
	events via the input layer
From: Corentin Chary <corentin.chary@gmail.com>
To: Richard Hughes <hughsient@gmail.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       gnome-power-manager-list@gnome.org,
       acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 10:47 AM, Richard Hughes<hughsient@gmail.com> wrote:
> On Tue, Jun 16, 2009 at 9:34 AM, Alan
> Jenkins<alan-jenkins@tuffmail.co.uk> wrote:
>> The driver doesn't.  As far as we know, none of them do.  Firmware does.
>
> In that case there's a "laptop_panel.brightness_in_hardware" hal quirk
> that turns off all the fancy stuff, and makes the GUI DTRT without
> guessing.
>
> Richard.
>

Ok, so we just need to patch this file :
http://cgit.freedesktop.org/hal-info/tree/fdi/information/10freedesktop/10-laptop-panel-hardware.fdi
?
If found it /usr/share/hal/fdi/information/10freedesktop/

But I'm not sure how to do it to make it works on all Eeepc.

-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
