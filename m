Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbXJYT4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbXJYT4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbXJYT4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:56:03 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:39897 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbXJYT4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:56:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=Uco1ltISn8E/0dk8FWGlh9nStM5OhpbjbDfI9Sl8EK+CsUijEb66RnoYh5kNnhT3bc92kxSB9ZoYDBBt+/nZJUf4R5hB4gH1uuj0PbO9VXPE81rgdBjlpiLquLbMGOzO;
Message-ID: <4720F4C9.9000908@simon.arlott.org.uk>
Date: Thu, 25 Oct 2007 20:55:53 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux machines dieing in swap storms
References: <1193325641.5776.21.camel@localhost.localdomain>
In-Reply-To: <1193325641.5776.21.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/10/07 16:20, Richard Purdie wrote:
> This isn't a new problem. My mail server used to be running an ancient
> 2.6.12 kernel and I upgraded it to 2.6.22.X in an effort to solve this
> problem which no change. My desktop shows exactly the same kind of OOM
> swap storm behaviour (2.6.20 based).
> 
> I realise that tuning the OOM killer is a really tricky problem but
> something needs improving as the current user experience is broken.
> 
> I'm seriously tempted to add a "kill the process using the most memory"
> key combination into SysRq which might let me save the desktop but won't
> help with my remote server. I could also just disable swap I guess.

I have no swap. If I accidentally start The GIMP and load a very large 
image, everything just freezes and I have to reboot - the OOM killer 
doesn't appear to care.

-- 
Simon Arlott
