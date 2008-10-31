Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbYJaRLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbYJaRLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 13:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYJaRL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 13:11:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52597 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYJaRL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:11:28 -0400
Date: Fri, 31 Oct 2008 17:11:26 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4 and 5
Message-ID: <20081031171126.GA17313@srcf.ucam.org>
References: <490B3BB5.8060801@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490B3BB5.8060801@tuffmail.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 05:09:09PM +0000, Alan Jenkins wrote:
> Did you miss a call to rfkill_force_state() on resume?

Conceivably. I didn't test the hibernation case.

> Actually, normal boot doesn't preserve the setting either.  Your commit
> changes the behaviour from the rfkill state being persistent across
> reboot / power off (as a bios setting), to being always enabled on
> boot.  It seems like a bad idea to me.

This is the behaviour of the rfkill core.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
