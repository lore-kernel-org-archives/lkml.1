Return-Path: <linux-kernel-owner+w=401wt.eu-S1759173AbZFMNkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173AbZFMNkP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZFMNkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:40:04 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:62724 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652AbZFMNkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:40:03 -0400
Date: Sat, 13 Jun 2009 13:55:38 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 2.6.29] eeepc-laptop: report brightness control events via  the input layer
Message-ID: <507032D758%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <71cd59b00906130306w319c0fc2i376bb03323845b80@mail.gmail.com>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk> 
 <20090404041813.GA30746@srcf.ucam.org> 
 <9b2b86520906080824i134ee546v33990176b0d3e618@mail.gmail.com> 
 <71cd59b00906130155u2757ade3t3378685846b80410@mail.gmail.com> 
 <4A337251.7010705@tuffmail.co.uk> 
 <71cd59b00906130306w319c0fc2i376bb03323845b80@mail.gmail.com>
Mail-Followup-To: Corentin Chary <corentin.chary@gmail.com>, Alan Jenkins 
 <alan-jenkins@tuffmail.co.uk>, linux-kernel@vger.kernel.org, 
 acpi4asus-user@lists.sourceforge.net, Matthew Garrett <mjg59@srcf.ucam.org>, 
 Darren Salt <linux@youmustbejoking.demon.co.uk>
User-Agent: Messenger-Pro/2.58.3.3080 (Qt/4.5.1) (Linux-x86_64)
X-NuLabour-Date: Sat, 8961 Dec 1984 13:55:38 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I demand that Corentin Chary may or may not have written...

> On Sat, Jun 13, 2009 at 11:33 AM, Alan Jenkins<alan-jenkins@tuffmail.co.uk>
> wrote:
[snip]
>> The firmware still changes the brightness immediately.  It seems
>> that when g-p-m gets delayed, it responds _wrongly_. It doesn't realize
>> that the firmware already changed the brightness, so it changes the
>> brightness again.

Should it be changing the brightness at all? I ask because every laptop which
I've used will change the brightness without userspace being involved.
(Although it's possible that g-p-m might get brightness-change events from
some source other than that which is used to report the laptop's own
brightness controls...)

[snip]
> Version: 2.24.2-2ubuntu8
> Ok I can reproduce [the brightness being changed inappropriately from
> userspace].

> I want to check if we can't fix g-p-m before reverting the patch. If
> there is no way to fix it, I'll revert.

I don't see that it can ever be reliable in the face of the brightness having
already been changed without userspace involvement short of being able to
tell it to report only on some/all events from some input devices.

-- 
| Darren Salt      | linux at youmustbejoking | nr. Ashington, | Doon
| Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
| + Generate power using sun, wind, water, nuclear.      FORGET COAL AND OIL.

A foolish consistency is the hobgoblin of little minds.
