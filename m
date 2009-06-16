Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbZFPIer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbZFPIer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZFPIed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:34:33 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:54574 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbZFPIeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:34:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qHhuVEfHD+R1/hRrojmnaF26HjFkbcAfO8ARaL+XSalq0jisrG0+Y9UfSfzWUlFGQy
         J534GgVRKGG4QMD2i5dQyeKzAWenbe/52iy0CNgkxUY2edi4IIJ4WN//BPITozPHIn/Z
         eeBC6l0KZ5lX8nwU+5kPMMmBSTBeJ3o+bkAc0=
Message-ID: <4A375914.5050800@tuffmail.co.uk>
Date: Tue, 16 Jun 2009 09:34:28 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Richard Hughes <hughsient@gmail.com>
CC: gnome-power-manager-list@gnome.org, acpi4asus-user@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Corentin Chary <corentin.chary@gmail.com>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [gpm] [PATCH 2.6.29] eeepc-laptop: report brightness control
 events via the input layer
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>	 <20090404041813.GA30746@srcf.ucam.org>	 <9b2b86520906080824i134ee546v33990176b0d3e618@mail.gmail.com>	 <71cd59b00906130155u2757ade3t3378685846b80410@mail.gmail.com>	 <4A337251.7010705@tuffmail.co.uk>	 <71cd59b00906130306w319c0fc2i376bb03323845b80@mail.gmail.com>	 <507032D758%linux@youmustbejoking.demon.co.uk>	 <9b2b86520906131051t32183554r8208cf886609e09c@mail.gmail.com>	 <71cd59b00906141226k37b90b9ey7347ed85ec17a17b@mail.gmail.com>	 <61b223ba0906150109r3a69e98aq949c7f2df5563c6e@mail.gmail.com> <15e53e180906160133j7055536cqe5b9515704fd4d94@mail.gmail.com>
In-Reply-To: <15e53e180906160133j7055536cqe5b9515704fd4d94@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Hughes wrote:
> On Mon, Jun 15, 2009 at 9:09 AM, Alan
> Jenkins<alan-jenkins@tuffmail.co.uk> wrote:
>   
>> So during step iii) I think you see the firmware
>> increase the brightness, then g-p-m decrease the brightness, and then
>> g-p-m catches up and the brightness increases again.
>>     
>
> Sorry for not responding sooner, been moving house.
>
> I don't think the kernel driver should modify the brightness itself,
> as that's applying policy. Is this is left to userspace then we can
> put on policy such as "don't allow brightness to be set below 30%" or
> "automatically set the brightness using a ambient light sensor, and
> use the brightness keys to set ambient thresholds".
>
> Doing this policy in the driver is the wrong thing to do IMO.
>
> Richard.
>   

The driver doesn't.  As far as we know, none of them do.  Firmware does.

Thanks
Alan
