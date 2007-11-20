Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbXKTFNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbXKTFNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbXKTFMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:12:52 -0500
Received: from smtp120.plus.mail.mud.yahoo.com ([209.191.106.151]:25133 "HELO
	smtp120.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752418AbXKTFMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:12:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=DtoB2Q2iRitrZ9oX4SEQzNQ7CtimpGEMp+mdnMdCfyQWrjCzJHlorFmhnqjKSedtZTFBja1/5L0+U2qSTQN8aW6rSJss62xNw4IxB0Z3LaRaaZiMqf8GBuZWVeZvCohBehD9wY821Q74n2QWFZL91yU2yvV96YeR4RbuBs+QAX4=  ;
X-YMail-OSG: Tw_IImQVM1ki0T2FQoOaB3nG_mGtqAyswflzaxLJl13Z3UdMiLESeGLMQW42fVyOJRTHkb0mxA--
Date: Tue, 20 Nov 2007 06:12:33 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [rfc-patch 0/9] Immediate Values for 2.6.24-rc2-git5
Message-ID: <20071120051232.GA7210@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20071116200238.740495156@polymtl.ca> <20071117125007.GA4450@gollum.tnic> <20071119153139.GA24454@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071119153139.GA24454@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 10:31:39AM -0500, Mathieu Desnoyers wrote:
> * Borislav Petkov (bbpetkov@yahoo.de) wrote:
> > On Fri, Nov 16, 2007 at 03:02:38PM -0500, Mathieu Desnoyers wrote:
> > Hi, 
> > just a conventions proposal: have you thought of shortening all those
> > "immediate_foo" prefixes to 'imm_foo', for example? This'll make the 
> > code much more readable, i think.
> > 
> 
> Hrm, a quick grep in the kernel tree shows me that the imm_* namespace
> is already quite clobbered (although I do not detect any imm_read or
> imm_set). 

Right, something called "low level driver for the IOMEGA MatchMaker"
(drivers/scsi/imm.c) has gotten hold of the imm_* prefix already so there might
be a problem later, probably. Nevertheless, you could use the imm_ prefix or
choose some other 3-n letter prefix:

immed_* (3 matches)
imme_* (no matches but dumb)
imd_* (none!)
immv_* (none, v like [v]alues), etc.
...

-- 
Regards/Gruﬂ,
    Boris.
