Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbYIEJTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbYIEJTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYIEJTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:19:25 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:33680 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbYIEJTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:19:24 -0400
From: Bernd Schubert <bs@q-leap.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: frame unwinder patches
Date: Fri, 5 Sep 2008 11:19:21 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <g9p3du$n95$1@ger.gmane.org> <20080904102936.28e10c39@infradead.org>
In-Reply-To: <20080904102936.28e10c39@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809051119.21699.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 September 2008 19:29:36 Arjan van de Ven wrote:
> On Thu, 04 Sep 2008 18:46:52 +0200
>
> Bernd Schubert <bs@q-leap.de> wrote:
> > Hello,
> >
> > up to 2.6.22 the -mm series had these nice frame unwinder patches,
> > which gave beautiful stack traces. Unfortunately these frame unwinder
> > patches seem to have been dropped :(
> >
> > Anyone still maintaining updated patches?
> >
> > Probably all the "?" lines shouldn't be printed.
>
> printing the ? lines is the result of a compromise between getting the
> most reliable information out of a stack trace, and getting a useful
> data for the case where not everything is going as well as it should.
>
> not printing the ? would be trivial (for some backtraces we do that),
> but so far hasn't been seen as desirable because you lose information
> in those hard-to-debug cases when you need anything you can get from
> the backtrace.

I see your point, but in most cases it is rather annoying.


Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
