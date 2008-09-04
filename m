Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbYIDR3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbYIDR3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbYIDR3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 13:29:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:36916 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYIDR3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 13:29:33 -0400
Date: Thu, 4 Sep 2008 10:29:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: frame unwinder patches
Message-ID: <20080904102936.28e10c39@infradead.org>
In-Reply-To: <g9p3du$n95$1@ger.gmane.org>
References: <g9p3du$n95$1@ger.gmane.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2008 18:46:52 +0200
Bernd Schubert <bs@q-leap.de> wrote:

> Hello,
> 
> up to 2.6.22 the -mm series had these nice frame unwinder patches, 
> which gave beautiful stack traces. Unfortunately these frame unwinder
> patches seem to have been dropped :(
> 
> Anyone still maintaining updated patches?
> 
> Probably all the "?" lines shouldn't be printed.

printing the ? lines is the result of a compromise between getting the
most reliable information out of a stack trace, and getting a useful
data for the case where not everything is going as well as it should.

not printing the ? would be trivial (for some backtraces we do that),
but so far hasn't been seen as desirable because you lose information
in those hard-to-debug cases when you need anything you can get from
the backtrace.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
