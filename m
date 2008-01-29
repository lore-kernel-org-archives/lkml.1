Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbYA2RMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbYA2RMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbYA2RL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:11:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:63660 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYA2RLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:11:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bY/pcjrtICnFfW7bJiYSYDnzzqZKQdOSfJyWkDwROQIBuz+8A5DVabfvj2xKSIY1RzxWDzrBo9+3LQZaGOaTk6zXPYKbYJjEZU8g7EPQqVkEXqLQFw09Gi2a1Cn4FxA6FpGn8Q+A064JTydZ9ESHtjKUOIVRjs24bfO+IPQsRR8=
Date: Tue, 29 Jan 2008 18:11:23 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matt Mackall <mpm@selenic.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>
Subject: Re: "inconsistent lock state" (netconsole/net related)
Message-ID: <20080129171117.GC23544@joi>
References: <20080127145314.GA6223@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127145314.GA6223@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 03:53:34PM +0100, Marcin Slusarz wrote:
> Hi
> 
> My box is locking up on start of X.org so I enabled netconsole
> and at every boot I'm getting:
> 
(...)
> 
> I'm on latest git (326e96b92306b7af24a3608ec01156cba17a3fc1: printk: revert ktime_get() timestamps).
> If you want more informations just ask.
> 
> Now I'm going to bisect lockup because netconsole didn't help...
Just to let you know: it suddenly stopped locking up. Strange...

Marcin
