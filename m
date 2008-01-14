Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbYANQLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbYANQLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYANQK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:10:57 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:13151 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYANQK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:10:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=vdqh1XCAkCxcdYYKt0gt1X7NWNkOmoxUsDyEdt9dJmtJcg4UFkj9frRlA7shrTXIFKxM4X//yMiWzzDiyw5P/67Nx5FCokP5JqlTB0TrzWuqnh5jRwq9E3VSdi/pg2wGx8vQMvp64jzF9LTnDk2fwGtKoNT7R2oJyxBBIGObTW0=
Message-ID: <b6c5339f0801140810s54ab5d39t2eb2d97c253089b0@mail.gmail.com>
Date: Mon, 14 Jan 2008 11:10:54 -0500
From: me@bobcopeland.com
To: "Tuomo Valkonen" <tuomov@iki.fi>
Subject: Re: The ext3 way of journalling
Cc: "Theodore Tso" <tytso@mit.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080114071555.GA6475@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18307.42821.166376.732473@stoffel.org>
	 <871w8r6ruc.fsf@barad-dur.regala.cx>
	 <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi>
	 <20080110131659.GF10230@mit.edu>
	 <20080110134111.GA6254@jolt.modeemi.cs.tut.fi>
	 <20080112150621.GC6751@mit.edu>
	 <20080113221301.GA18341@jolt.modeemi.cs.tut.fi>
	 <20080113222310.GA20815@jolt.modeemi.cs.tut.fi>
	 <20080113231150.GB23906@mit.edu>
	 <20080114071555.GA6475@jolt.modeemi.cs.tut.fi>
X-Google-Sender-Auth: 1b91e986d2c57d0c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/14/08, Tuomo Valkonen <tuomov@iki.fi> wrote:
> On 2008-01-13 18:11 -0500, Theodore Tso wrote:
> > It's much more likely that this early in your boot cycle, your clock is
> > sometimes incorrect.
>
> I doubt it. I get this nearly _always_ when the system crashes, which
> accounts for the vast majority of the times I boot it. (I wish swsusp
> didn't suck so much..)

It sounds like you have CONFIG_PM_TRACE turned on.  From the Kconfig help:

    This enables some cheesy code to save the last PM event point in the
    RTC across reboots, so that you can debug a machine that just hangs
    during suspend (or more commonly, during resume).

[...]

    CAUTION: this option will cause your machine's real-time clock to be
    set to an invalid time after a resume.

-Bob
