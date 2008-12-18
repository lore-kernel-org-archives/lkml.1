Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752731AbYLRLCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbYLRLCY (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbYLRLCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:02:15 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:27811 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750897AbYLRLCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:02:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=O8QUOHjHRiTTLcj6JC2P6aqdtR48mT88WtfJOYL3kWanhpLNJ/fVqwKhjm9NVJgt3ys0Ueji1RCLfxtVQiq1PWWa6b7gazRliaViPJH/8S0Nda30oJAfNrUNma0TwItkARjTHYlZX2CwNt083kODwPx8QdUCdksBMoMizNyciRU=  ;
X-YMail-OSG: v0r8C3wVM1kt5EYwqLTUE2WwOr1_lmstsqSgc4sQuEPdBOoYL4uSrS_V96FUjblSlIOfzdffgBUhYd0lb3VRJxz78e.BeoGV1kvzyze0MOKK2rEV.8Z5PF_M5tUrQR4H4RJIgHwYvtDuKCV5.ZJF0BULVGg8J98_BvMvvne_1prlmO6HIZtjAQHLFPl5JBsK2ZhDwKWlpGBEqO1WBBbwQyvZMJopgrBypg8hvGXk.FIdnVSQ5R4K2PV43ZzNP3jesUskd4ANG6AM.3xTA7wT0YCi8STFRsPJ60jXSjuC4iuGJZueIPxrPiEE6GLKboDHhmW7LcAieP7pmT1DgtLVRCsfhwo-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Samuel Ortiz <sameo@openedhand.com>
Subject: Re: linux-next: Tree for December 15 (mfd)
Date: Thu, 18 Dec 2008 03:02:12 -0800
User-Agent: KMail/1.9.10
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20081216020642.fc1007d9.sfr@canb.auug.org.au> <20081217114300.9476f8da.randy.dunlap@oracle.com> <20081218105700.GC2517@sortiz.org>
In-Reply-To: <20081218105700.GC2517@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812180302.12412.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2008, Samuel Ortiz wrote:
> David, are you ok with this fix:
> http://git.o-hand.com/cgit.cgi/linux-mfd/commit/?h=for-next&id=1e6b6a411fd4f6f99e4d9f003946823007e3c34f

I'd rather remove that "if (can't happen) { pr_err, return }"
code myself ... otherwise, sure.

- Dave
