Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbYL1UTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbYL1UTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 15:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYL1UTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 15:19:41 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50913 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYL1UTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 15:19:40 -0500
Date: Sun, 28 Dec 2008 20:19:36 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH, resend] relatime: Let relatime update atime at least once per day
Message-ID: <20081228201936.GA19563@srcf.ucam.org>
References: <20081228152901.GB13565@srcf.ucam.org> <alpine.LNX.2.00.0812281928370.10294@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0812281928370.10294@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 07:35:25PM +0100, Jesper Juhl wrote:

> Not all days are 24*60*60 seconds long. Daylight savings time as well as 
> leap seconds make this an inaccurate/incorrect constant for representing 
> "one day".
> I don't think we really care, but perhaps the comment above should 
> acknowledge the fact that this is aproximately one day?

"Day" in the ISO 8601 sense, ie:

2.2.5 day
unit of time, equal to 24 hours

as opposed to

2.2.6 calendar day
time interval starting at midnight and ending at the next midnight, the 
latter being also the starting instant of the next calendar day

-- 
Matthew Garrett | mjg59@srcf.ucam.org
