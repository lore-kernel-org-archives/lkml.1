Return-Path: <linux-kernel-owner+w=401wt.eu-S1757778AbYGGS6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbYGGS6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYGGS6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:58:08 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52767 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbYGGS6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:58:07 -0400
Date: Mon, 7 Jul 2008 20:58:05 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: "H. Peter Anvin" <hpa@kernel.org>
cc: Nicolas Ferre <nicolas.ferre@atmel.com>, webmaster@kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: git pull through http / git
In-Reply-To: <48725A7F.7040409@kernel.org>
Message-ID: <alpine.LNX.1.10.0807072052510.8248@fbirervta.pbzchgretzou.qr>
References: <48724130.5050501@atmel.com> <alpine.LNX.1.10.0807071840470.8248@fbirervta.pbzchgretzou.qr> <48725A7F.7040409@kernel.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-07-07 20:03, H. Peter Anvin wrote:

> Jan Engelhardt wrote:
>> 
>> I don't think many care about http downloading, just because it is available
>> as such.
>> git:// and rsync:// are available though and should be usable even without
>> the http info that needs to be constantly refreshed when one wants to use
>> http....
>
> I thought rsync:// had the same problem (dumb transport) as http://.

I thought the opposite (read: no way to prove it).
rsync has a possibility to list a directory, whereas this is not 
possible with HTTP (you always get a fancy html index page or a 
Directory Listing Denied), hence it can figure out all objects that are 
possibly located in the repository.

> I have made some sketches on a git-aware http protocol to deal with 
> the "idiot IT department-managed firewall" problem; however, I have 
> not had time to implement it.

Not wanting to downplay your work, but I'd be happier if they
would not get to have their githttp in the hope  that these
IT departments get a clue that http is not a fits-it-all solution.

Because once the workers can't do their job because the world is 
Git-dominated, they have to turn it on. But maybe then they still don't 
get the clue...hmm
tricky situation :)

