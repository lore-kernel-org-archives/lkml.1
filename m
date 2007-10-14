Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbXJNKjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbXJNKjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 06:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbXJNKjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 06:39:05 -0400
Received: from [212.12.190.105] ([212.12.190.105]:38273 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755367AbXJNKjC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 06:39:02 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [2.6.20.21 review 12/35] TCP: Fix TCP handling of SACK in
Date: Sun, 14 Oct 2007 13:38:51 +0300
User-Agent: KMail/1.5
Cc: netdev@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200710141338.51927.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ilpo Järvinen wrote:
> Willy Tarreau wrote:
> > I agree with this. The impression I got from the description of the two
> > patches I merged was that the problems they fix were quite annoying. But
> > maybe I should take that with a grain of salt.
>
> No, it's not a grain of salt. I would say its utterly broken, out loud.
> But many people are not that much into time-seq graphs (that I'm familiar
> with), they are pleased when it seems to work well enough even though
> from my perspective, it is simply unacceptable in worst cases (not
> speaking of theoretical ones here, have seen very bad performance). Not
> that it always is that bad, depends on phase of the opposite direction
> what happens.
>
> Somebody asked me when those four patches were made about this, I put
> these there back then:
>
> http://www.cs.helsinki.fi/u/ijjarvin/bidir-showcase/
>
> They are generated from my old test archives and thus may have a bit
> differences in TCP variant, which may slightly differ from mainline
> here and there (my point was just to show how it breaks). Typical
> people wouldn't even notice those minor differences compared with the
> bidir brokeness which is very visible in all except in the fixed "ok"
> case. Please judge for yourself whether I overexaggrated or not... :-)

It would probably be helpful, if you could post a specific testcase and a 
combo-patch of your fixes.


Thanks!

--
Al

