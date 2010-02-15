Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0BODJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 22:09:11 -0500
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:45858 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754526Ab0BODJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 22:09:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vRHrDDvwaf9akahdIlx8dsWtI0nf8Marcl/oxcJPgS2fBuidx01PwNU/ShnWM5wSLiOJSgOaJp2dHyP0ZOB7BXRQ3CA1uNmyla+Lsi7NSuoR77A9VMVMCPtyB5gTMl9FmvMX7A8GDc9YTuS6lrBqFY8P5UZ568BuPydd8iE4eh8=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: .aiOqJgVM1ls0PZdv0ayKYJGyVpE4_dBVoRqVwno.u_2gW5a9dGsNDQGziaqhgO9bFJijrsvz8NETqu9poUhAp6sTzaNt.5_j4DWUQJwqtCqBchkkX5VrhBcNOTXP_AMajBXqz3EsQ2Ut466Hah4V1OstuYJQxwR3OA6i5jphjrfiPH7VsTOJVe5nw.ut4Btx1TxTZXy1DeqlBd.bAcu7xegBm_ZlLTfR7BCaDldBdOgdwsJXq9twPlH.BcH0Wms
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/2] usbnet: Convert dev(dbg|err|warn|info) macros to netdev_<level>
Date: Sun, 14 Feb 2010 19:09:06 -0800
User-Agent: KMail/1.9.10
Cc: Tilman Schmidt <tilman@imap.cc>, David Miller <davem@davemloft.net>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100212.123837.56526847.davem@davemloft.net> <4B7892AA.7000305@imap.cc> <1266195287.16721.953.camel@Joe-Laptop.home>
In-Reply-To: <1266195287.16721.953.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <201002141909.06541.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 February 2010, Joe Perches wrote:
> I'll resend in a bit after David Brownell or
> someone else answers the inverted question below.
> 
> > Btw, is it intentional that the _OTHER values are printed after the
> > label "this", and the _THIS values after the label "other"?
> 
> Thanks again, I saw that, but neglected to mention it.
> David Brownell?  Do you know if that is inverted?

I'd call that a bug.  Note that this is specific to the net1080
chip, which hasn't been manufactured for quite a few years now
and was never hugely popular ... so the significance of getting
that rarely-seen diagnostic wrong was minor.

- Dave



