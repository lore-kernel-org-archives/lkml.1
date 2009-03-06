Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZCFWs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZCFWs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbZCFWsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:48:47 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:24360 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751309AbZCFWsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:48:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dpD/XHWCiEluzA092iOZc501kyibvMHIpwVMTfGVRwaaxMcLD1eV+C6GbkUeM8nS0GNcsECTuQp7aGdsPmfM4UnysO+dnaYqZmepQ+LwVwoOaVVD/Gkq16ku8ziKj3eMIrudyvVWDwL1gKDTQJZXq42FqFi3R1mMbbpBy5i7qwU=  ;
X-YMail-OSG: VPcUf0IVM1mUUnBlaH7AdUDjuDnHBLEz1V3MXBPVyzhPffprFDEai3IjcHO5aGQlDOFQGLrpRbuW.ZfNDc_9b3qtAstM5lqj2sN9r.WD_wxRvVSXf0hZs2fsYw.C8AhBlQzxIWdS0qHFJzQvES9s0Tfy
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [PATCH] regulator: twl4030 VAUX3 supports 3.0V
Date: Fri, 6 Mar 2009 14:48:43 -0800
User-Agent: KMail/1.9.10
Cc: Adrian Hunter <adrian.hunter@nokia.com>, lrg@slimlogic.co.uk,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-omap Mailing List" <linux-omap@vger.kernel.org>
References: <49B11EB0.30809@nokia.com> <200903061116.21544.david-b@pacbell.net> <20090306221842.GB15728@sirena.org.uk>
In-Reply-To: <20090306221842.GB15728@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903061448.43749.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 March 2009, Mark Brown wrote:
> Would it make sense to make this platform data so that if a given board
> requires running the chip like this it can be enabled for those boards
> but it's not something people might turn on because it seems useful?

Let's hear if it's actually needed, first.  :)

I coded those tables so that it would be easy to kick in the
support for out-of-spec operation if it's really needed.  But
so far we don't know that it's needed, and I'd rather it not
be too easy to run like that.

- Dave


