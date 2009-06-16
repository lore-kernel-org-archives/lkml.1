Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbZFPIig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbZFPIig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbZFPIiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:38:23 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:43232 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbZFPIiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:38:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b3Orm4hRKER7T9vsldgyDuXoNCei7Ays9axf5lN6+K0DOUzuxeqSR8eE4qDmneldkd
         x62kzflf9VIPQa5k3UWfT1vH/CcR/lDuuW6Q/UYX5WrNfpplyInvu6wJ5XNgtAEOE7h3
         BeQkYdtku7VJgysyTAw7LS/lUS7dl8jtT053c=
MIME-Version: 1.0
In-Reply-To: <61b223ba0906150109r3a69e98aq949c7f2df5563c6e@mail.gmail.com>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>
	 <20090404041813.GA30746@srcf.ucam.org>
	 <9b2b86520906080824i134ee546v33990176b0d3e618@mail.gmail.com>
	 <71cd59b00906130155u2757ade3t3378685846b80410@mail.gmail.com>
	 <4A337251.7010705@tuffmail.co.uk>
	 <71cd59b00906130306w319c0fc2i376bb03323845b80@mail.gmail.com>
	 <507032D758%linux@youmustbejoking.demon.co.uk>
	 <9b2b86520906131051t32183554r8208cf886609e09c@mail.gmail.com>
	 <71cd59b00906141226k37b90b9ey7347ed85ec17a17b@mail.gmail.com>
	 <61b223ba0906150109r3a69e98aq949c7f2df5563c6e@mail.gmail.com>
Date: Tue, 16 Jun 2009 09:33:22 +0100
Message-ID: <15e53e180906160133j7055536cqe5b9515704fd4d94@mail.gmail.com>
Subject: Re: [gpm] [PATCH 2.6.29] eeepc-laptop: report brightness control 
	events via the input layer
From: Richard Hughes <hughsient@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: gnome-power-manager-list@gnome.org, acpi4asus-user@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Corentin Chary <corentin.chary@gmail.com>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 9:09 AM, Alan
Jenkins<alan-jenkins@tuffmail.co.uk> wrote:
> So during step iii) I think you see the firmware
> increase the brightness, then g-p-m decrease the brightness, and then
> g-p-m catches up and the brightness increases again.

Sorry for not responding sooner, been moving house.

I don't think the kernel driver should modify the brightness itself,
as that's applying policy. Is this is left to userspace then we can
put on policy such as "don't allow brightness to be set below 30%" or
"automatically set the brightness using a ambient light sensor, and
use the brightness keys to set ambient thresholds".

Doing this policy in the driver is the wrong thing to do IMO.

Richard.
