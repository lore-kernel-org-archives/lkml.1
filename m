Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbXKSMWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbXKSMWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 07:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXKSMWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 07:22:33 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:33655 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbXKSMWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 07:22:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=MxY3Vgo1779RdYsUhtWk+E8fqCZfwfi8w5PG5Tc9f7HKkM6btCuFOynziemGkqCpUmydly2zF4L/a3UgJUjIckh4ng99XoSO+MeSIWFrZNoiUh6JA8dNlErrSpMqHaA5;
Message-ID: <53552.simon.1195474940@5ec7c279.invalid>
In-Reply-To: <20071117184030.GA5541@electric-eye.fr.zoreil.com>
References: <473F0FE0.3010501@tragetaschen.dyndns.org>
    <20071117184030.GA5541@electric-eye.fr.zoreil.com>
Date: Mon, 19 Nov 2007 12:22:20 -0000
Subject: Re: Bogus PCI vendor ID
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Francois Romieu" <romieu@fr.zoreil.com>
Cc: "Kai Ruhnau" <kai@tragetaschen.dyndns.org>,
       "LKML" <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, November 17, 2007 18:40, Francois Romieu wrote:
> Kai Ruhnau <kai@tragetaschen.dyndns.org> :
> [...]
>> I have a problem with two of my PCI devices showing the wrong PCI vendor
>> ID (0001) in vanilla kernels.

Have you tried doing a cold boot at every test? I've had bogus PCI IDs
appear before where it was the device's fault, and the ID would change
after the first boot.

-- 
Simon Arlott
