Return-Path: <linux-kernel-owner+w=401wt.eu-S969109AbXFHLoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969109AbXFHLoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 07:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968340AbXFHLor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 07:44:47 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45123 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966642AbXFHLor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 07:44:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=AkO0YGNO1sWz33bB48Yk12qP0ke0ie9tiulNFTI54OcTeN0hmRxlcSGfpd0OXFpxhKikwMlL4x9/wv+FrBWXIjFH4Qd4Av2yxnNJGYu73dPGaZzgQ0rDKPPdLx3bLETB;
Message-ID: <17035.simon.1181303078@5ec7c279.invalid>
In-Reply-To: <20070607145744.GY11166@waste.org>
References: <Pine.LNX.4.64.0706061753190.3697@p34.internal.lan>
    <20070607145744.GY11166@waste.org>
Date: Fri, 8 Jun 2007 12:44:38 +0100
Subject: Re: Kernel 2.6.22-rc4 netconsole & syslogd bug
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Matt Mackall" <mpm@selenic.com>
Cc: "Justin Piszcz" <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, June 7, 2007 15:57, Matt Mackall wrote:
>> Do I need to be running some sort of special netconsole server and send to
>> a different port to avoid this spam?
>
> A lot of people simply run netcat.

There's cancd; syslogd isn't really appropriate because printks aren't always whole lines and each one is
sent as a separate packet.

-- 
Simon Arlott
