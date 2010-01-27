Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215Ab0A0Ljd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab0A0Ljd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056Ab0A0Ljb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:39:31 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:40372 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915Ab0A0Lja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:39:30 -0500
X-Greylist: delayed 1777 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jan 2010 06:39:29 EST
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o0RB9lG6015540
Subject: Re: bug list: assigning negative values to unsigned variables
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Julia Lawall <julia@diku.dk>
Cc: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1001271155430.20256@ask.diku.dk>
References: <20100127104011.GA24796@bicker>
	 <Pine.LNX.4.64.1001271155430.20256@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 12:09:46 +0100
Message-ID: <1264590586.9749.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-Misty-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2010-01-27 at 11:57 +0100, Julia Lawall wrote:
> On Wed, 27 Jan 2010, Dan Carpenter wrote:
> 
> > Fixing the places which assign negative values to unsigned variables is a good janitor task.
> 
> I had the impression that assignment to -1 was done sometimes as a 
> portable way to initialize the variable to 0xffff (for any number of f's).  
> So perhaps it is not so trivial to fix.
Any particular reason that ~0U, ~0UL, and ~0ULL shouldn't do the same
(without relying on conversion from signed to unsigned)?

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

