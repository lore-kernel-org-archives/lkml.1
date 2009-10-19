Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbZJSSH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbZJSSH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 14:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbZJSSH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 14:07:27 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:51226 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbZJSSH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 14:07:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p08COSPID+fWonBhZeogXxwL2WoPbYFjGG2dkG+cbppHiZnvhk6nvl0CEYW0h4ZQRb
         PPL3UxPxAbJ0RVa+cWoGXudDpFf/SCjQhlalPx9JDpN+4sswOhDZBKqQH4ZsZmgEPl3K
         DXLEaGyam/AojhwLC43A9Z1dDwM2AGY/M0kPM=
Date: Mon, 19 Oct 2009 20:07:12 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: tomoki.sekiyama.qu@hitachi.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       satoshi.oshima.fk@hitachi.com, hidehiro.kawai.ez@hitachi.com,
       hideo.aoki.tk@hitachi.com
Subject: Re: [PATCH] AF_UNIX: Fix deadlock on connecting to shutdown socket
Message-ID: <20091019180712.GA2959@ami.dom.local>
References: <4ADC010C.5070809@hitachi.com>
 <20091019115713.GB6869@ff.dom.local>
 <20091019.061459.193694892.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019.061459.193694892.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 06:14:59AM -0700, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Mon, 19 Oct 2009 11:57:13 +0000
> 
> > Isn't the shutdown call expected to change sk_state to TCP_CLOSE?
> 
> No, because the send side is still up and operational, it's
> only a half duplex close.

OK, thanks for the explanation,
Jarek P.
