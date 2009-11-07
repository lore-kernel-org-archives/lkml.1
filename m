Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbZKGRwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbZKGRwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 12:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZKGRwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 12:52:19 -0500
Received: from bamako.nerim.net ([62.4.17.28]:64188 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbZKGRwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 12:52:19 -0500
Date: Sat, 7 Nov 2009 18:52:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [78/99] hwmon: (it87) Fix VID reading on
 IT8718F/IT8720F
Message-ID: <20091107185222.18588dfb@hyperion.delvare>
In-Reply-To: <20091107153741.GB5607@1wt.eu>
References: <20091106221358.309857998@mini.kroah.org>
	<20091106221549.637855004@mini.kroah.org>
	<20091107153741.GB5607@1wt.eu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salut Willy,

On Sat, 7 Nov 2009 16:37:42 +0100, Willy Tarreau wrote:
> On Fri, Nov 06, 2009 at 02:15:16PM -0800, Greg KH wrote:
> > 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> 
> I noticed this one was not merged into 2.6.27.39. I suspect it is
> just because it did not apply since IT8720F was not present there.
> However I think the test still needs fixing, though I'm not well
> qualified to judge about that.
> 
> Jean, do you have any opinion on this matter ?

You are totally right. I originally wrote: "it won't apply to 2.6.27
because IT8720F support was added in 2.6.29. I'll send a separate patch
for 2.6.27." I wrote the patch in question but apparently forgot to
send it. My bad, I'll do that right now.

-- 
Jean Delvare
