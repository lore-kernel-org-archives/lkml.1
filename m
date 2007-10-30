Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbXJ3TYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbXJ3TYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbXJ3TVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:21:43 -0400
Received: from smtp121.iad.emailsrvr.com ([207.97.245.121]:47048 "EHLO
	smtp121.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626AbXJ3TVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:21:41 -0400
Message-ID: <47278439.4030801@gentoo.org>
Date: Tue, 30 Oct 2007 19:21:29 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070805)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org>	<20071030153417.59b9182c@the-village.bc.nu>	<47276DCA.1000808@gentoo.org> <20071030190153.373c9347@the-village.bc.nu>
In-Reply-To: <20071030190153.373c9347@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> I would guess Brasero is issuing a command with the length of data
> wrongly set. In the old code that might well just produce errors of the
> "Umm wtf is this data left over for ?", with the new code the drive is
> likely to change state as it knows the transfer size and that will
> *correctly* cause an HSM error and what follows.
> 
> Now the question is who gets the length wrong - Brasero or the ata
> translation code in libata

Brasero does exactly the same as my test app which I attached to my last 
mail. Is my test app wrong?

Daniel

