Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbYAJLX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbYAJLX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbYAJLXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:23:50 -0500
Received: from ns.suse.de ([195.135.220.2]:59525 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbYAJLXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:23:50 -0500
To: Jan Marek <linux@hazard.jcu.cz>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Is it possible to change IRQ for certain device?
From: Andi Kleen <andi@firstfloor.org>
References: <20080110110535.GA25706@hazard.jcu.cz>
Date: Thu, 10 Jan 2008 12:23:48 +0100
In-Reply-To: <20080110110535.GA25706@hazard.jcu.cz> (Jan Marek's message of "Thu\, 10 Jan 2008 12\:05\:35 +0100")
Message-ID: <p73myrdorej.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Marek <linux@hazard.jcu.cz> writes:
>
> Is there a way to change IRQ for VGA (or for ohci_hcd instead of VGA)
> directly in Linux?

Linux normally cannot change the interrupts assigned by the BIOS
because it often requires chipset specific knowledge.

-Andi
