Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYDEW7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYDEW7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 18:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYDEW7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 18:59:17 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:24252 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753695AbYDEW7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 18:59:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=c+TXjcCtDfmSz/wVrwAt8PZ9IXTSIXfyl+CuWW9VIzZrCxeVLvbpnu5o1RkueMaOTJJByB4Gjabvb6uy0Pg2g2hzQf7O6WG+oDREjm9mf3+xaBCQPXZOubCJAqKaeQFqWEYKefpmSkoFMreCtl8IlrGB39zG08lVeBKhZcyxmSE=  ;
X-YMail-OSG: XUjA4x0VM1lJQxotkYYBxiOooeu_t.HTM6UesMg7ePeiaXIzAi4dVglVN7fxpVUeXwkVYPPSGg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/1] [GPIO]: new arch-independent simple-gpio driver
Date: Sat, 5 Apr 2008 15:42:44 -0700
User-Agent: KMail/1.9.6
Cc: Bryan Wu <cooloney@kernel.org>, linux-kernel@vger.kernel.org
References: <> <1206579921-22221-1-git-send-email-cooloney@kernel.org> <1206597150.3315.48.camel@moss.renham>
In-Reply-To: <1206597150.3315.48.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804051542.44717.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 March 2008, Ben Nizette wrote:
> > +#define pr_devinit(fmt, args...) ({ static const __devinitdata char __fmt[] = fmt; printk(__fmt, ## args); })
> > +#define pr_init(fmt, args...) ({ static const __initdata char __fmt[] = fmt; printk(__fmt, ## args); })
> 
> Should your pr_*init macros be accepted somewhere higher up the tree?
> Either that or dropped, it doesn't seem right wedging them in here.
> Sure it might cost you a few hundred bytes of RAM but would be nice to
> keep it all consistent across the kernel.

Me, I'm all in favor of getting rid of structural code bloat.
A few hundred bytes of such stuff shaved out a dozen drivers
on a given platforms would be almost free page saved!  :)

So I'd be interested in seeing those get submitted ... but as
inline functions, not fancy macros.  (Once they're submitted,
then let the flamage begin ... much less than kernel I18N!)

- Dave

