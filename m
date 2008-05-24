Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbYEXQu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbYEXQu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 12:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbYEXQut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 12:50:49 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:48725 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756290AbYEXQus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 12:50:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=h7Z96L5tkJyvJReJlmceA0QPinBt0XhU3M6fFtjEarRCJq6O0ImXS6vOnVZbQaY101hnGO+/F/r510FYYn+WhXgbZwLfjpnSICeUDSEi2qIuGjMcHy+BF9wRKBGKmXc0s0enznUmTnFo6prz+3uGZa+XMQZuGQGncKJ+1k4AlE8=  ;
X-YMail-OSG: gLdcTQ4VM1nZq1kMer4ilTN2UkQ6PG__tDlX1dyxOOFnkQWxryrJYFkz3zyVqaPtnkthMuVWGVx__5lRgpzW8MtF_YzsFTjND6kc5iNCD15CofhXPXEoqwLY6gBZ5Zd1ZMs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [spi-devel-general] [PATCH 3/4] spi: Add OF binding support for SPI busses
Date: Sat, 24 May 2008 00:13:27 -0700
User-Agent: KMail/1.9.9
Cc: spi-devel-general@lists.sourceforge.net,
       "Segher Boessenkool" <segher@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       fabrizio.garetto@gmail.com,
       "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca> <200805221926.24112.david-b@pacbell.net> <fa686aa40805232325w65d4f706i50798121a8cce263@mail.gmail.com>
In-Reply-To: <fa686aa40805232325w65d4f706i50798121a8cce263@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805240013.28044.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2008, Grant Likely wrote:
> Very good point.  Okay, so we cannot assume any correlation between
> the number of CS lines and the number of child nodes to the SPI bus.

That wasn't what I was implying ... all the devices hooked
up to a given chipselect should be viewed as a single (albeit
composite) child node.

Now, the driver for that child node may want to expose lots
of substructure.  But that's no different from any other
complex device, whose protocol happens to embed some notion
of component addressing.

It's just that in the case I mentioned, that addressing is
a bit more externally visible than it is in some other cases.

- Dave

