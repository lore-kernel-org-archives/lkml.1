Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbXHCHdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbXHCHdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 03:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbXHCHdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 03:33:07 -0400
Received: from ns.firmix.at ([62.141.48.66]:40769 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbXHCHdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 03:33:06 -0400
Subject: Re: gcc fixed size char array initialization bug - known?
From: Bernd Petrovitsch <bernd@firmix.at>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Satyam Sharma <satyam@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070803034001.GA3476@localhost.localdomain>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
	 <Pine.LNX.4.64.0708022157310.9319@fbirervta.pbzchgretzou.qr>
	 <alpine.LFD.0.999.0708030841390.23798@enigma.security.iitk.ac.in>
	 <20070803034001.GA3476@localhost.localdomain>
Content-Type: text/plain
Organization: http://www.firmix.at/
Date: Fri, 03 Aug 2007 09:32:55 +0200
Message-Id: <1186126375.3677.1.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.332 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.332 required=5
X-Spam-Score: -2.332 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-03 at 11:40 +0800, WANG Cong wrote:
> On Fri, Aug 03, 2007 at 08:47:56AM +0530, Satyam Sharma wrote:
[....]
> >While we're talking of null-termination of strings, then I bet you
> >generally want to be using strlcpy(), really. Often strncpy() isn't
> >what you want. Of course, if that buffer isn't a string at all, then
> >you should be using memfoo() functions and not strbar() ones in the
> >first place ...
> 
> Afaik, strlcpy() and strlcat() are NOT standard C library functions.

Yes, because they are not old enough as they are results of lessons
learned with strncpy() and strcpy() and other buffer overflows.

> But, I know, they are available in Linux kernel. ;) And yes, they
> are better than strn{cpy,cat}().

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

