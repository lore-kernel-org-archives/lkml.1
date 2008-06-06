Return-Path: <linux-kernel-owner+w=401wt.eu-S933345AbYFFVul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbYFFVul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756304AbYFFVub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:50:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54154 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbYFFVua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:50:30 -0400
Date: Fri, 6 Jun 2008 22:50:20 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] isight_firmware: Avoid crash on loading invalid firmware
Message-ID: <20080606215020.GA21048@srcf.ucam.org>
References: <dd18b0c30806060137j7edc751se364ff21cfc8911b@mail.gmail.com> <20080606121136.GA9087@srcf.ucam.org> <20080606110711.a9a6a4f6.akpm@linux-foundation.org> <dd18b0c30806061110qd3100b4p1ee9f8ef493a56c6@mail.gmail.com> <dd18b0c30806061138h69c87d6am898a4eb409d379e1@mail.gmail.com> <20080606185548.GB8576@kroah.com> <20080606192135.GA16727@srcf.ucam.org> <20080606123511.38ffbdde.akpm@linux-foundation.org> <20080606194856.GA17708@srcf.ucam.org> <dd18b0c30806061414k6b7a2f04g87e7594066f0f015@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30806061414k6b7a2f04g87e7594066f0f015@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 09:14:27PM +0000, Justin Mattock wrote:
> Also not matlock(not the T.V. show). Now onto the status:  I think
> there might be something going on with this patch, or the module
> itself I keep getting ACPI EC: GPE storm
> detected(http://bugzilla.kernel.org/show_bug.cgi?id=10724) , yesterday
> I modified drivers/acpi/ec.c and was not receiving this message the
> rest of the day, after applying the patch to isight_firmware and
> loading, I'm receiving this message probably within 20 minutes of
> being up. Now I'm not sure If it's because I modified ec.c, or not
> that's causing this. I'll have to run a couple of experiments to see.
> has anybody seen the same message?
> regards;

Yeah, I've seen that too. Pretty sure it's unrelated.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
