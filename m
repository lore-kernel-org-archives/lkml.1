Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbYCPOOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbYCPOOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 10:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYCPON5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 10:13:57 -0400
Received: from ns.firmix.at ([62.141.48.66]:6161 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbYCPON5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 10:13:57 -0400
Subject: Re: checkpatch.pl and statics
From: Bernd Petrovitsch <bernd@firmix.at>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Andreas Westin XX <andreas.xx.westin@ericsson.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <47DD21E1.2080505@panasas.com>
References: <6006DAC0B81F85439BC960F36F929CDFB5F5EE@eseldmw101.eemea.ericsson.se>
	 <1205422989.3621.22.camel@tara.firmix.at>  <47DD21E1.2080505@panasas.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Sun, 16 Mar 2008 15:13:39 +0100
Message-Id: <1205676819.3815.48.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-8.fc7) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.332 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.332 required=5
X-Spam-Score: -2.332 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Son, 2008-03-16 at 15:34 +0200, Benny Halevy wrote:
> On Mar. 13, 2008, 17:43 +0200, Bernd Petrovitsch <bernd@firmix.at> wrote:
> > On Don, 2008-03-13 at 16:09 +0100, Andreas Westin XX wrote:
> > [....]
> >> I ran checkpatch.pl on a piece of code I wrote and besides all the other
> >> warnings/errors it complained about a static pointer being initialised
> >> to NULL/0. I fixed it but I'm curious as to why this is not permitted ?
> > 
> > Because "uninitialized" data is automatically initialized wit 0. An
> > explicit initialization with 0/NULL wastes space in the kernel image.
> 
> gcc (at least version >= 4.1.2) seems to smarter than that. It

That's good news (and new to me too).

> doesn't seem to put data initialized to zero in the initialized data
> segment but rather adds it to the uninitialized data. That said,
> initializing statically allocated data to zero is superfluous in C
> and should be avoided for style/elegance reasons as well.

Well, one can discuss endlessly about style and elegance ....

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

