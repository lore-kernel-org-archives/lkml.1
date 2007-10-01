Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbXJAU2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbXJAU2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbXJAU2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:28:23 -0400
Received: from web36609.mail.mud.yahoo.com ([209.191.85.26]:22971 "HELO
	web36609.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752222AbXJAU2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:28:22 -0400
X-YMail-OSG: BHsv0JYVM1ljlrS8UGs9LJiKotl8x6xBc.Odz8i.y0_WpPToiDGnXLFcNOUKxZj7oXusBxxNYA--
X-RocketYMMF: rancidfat
Date: Mon, 1 Oct 2007 13:28:21 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: Andi Kleen <ak@suse.de>, Theodore Tso <tytso@mit.edu>
Cc: Joshua Brindle <method@manicmethod.com>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       torvalds@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Paul Moore <paul.moore@hp.com>
In-Reply-To: <200709302205.58017.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <760457.44360.qm@web36609.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andi Kleen <ak@suse.de> wrote:


> Anyways; if someone wants to cripple their security for some
> performance this way they can surely do this; but i don't think we should 
> offer it as a default configuration option (just as we don't have a 
> CONFIG_NULL_LSM even though there are undoubtedly systems that don't
> care about permission checking[1]) 
> 
> -Andi
> 
> [1] I bet I gave the linux-tiny crowd an idea now ;-)

You would need authoritative LSM hooks for this. The current LSM
additional restrictions model does not provide for this.


Casey Schaufler
casey@schaufler-ca.com
