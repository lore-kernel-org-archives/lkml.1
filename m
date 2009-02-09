Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZBIWK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZBIWK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZBIWKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:10:11 -0500
Received: from genesysrack.ru ([195.178.208.66]:41036 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbZBIWKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:10:10 -0500
Date: Tue, 10 Feb 2009 01:09:59 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ian Dall <ian@beware.dropbear.id.au>
Subject: Re: [1/1] w1: w1 temp calculation overflow fix.
Message-ID: <20090209220959.GB15633@ioremap.net>
References: <20090209214217.GA14958@ioremap.net> <1234216124.5574.12.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234216124.5574.12.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 01:48:44PM -0800, Harvey Harrison (harvey.harrison@gmail.com) wrote:
> >  {
> > -	s16 t = (rom[1] << 8) | rom[0];
> > +	int t = ((s16)rom[1] << 8) | rom[0];
> 
> Alternatively,
> 
> 	int t = (s16)le16_to_cpup((__le16 *)rom);

Well, yes, but for the consistency with the other conversation functions
I think above is more appropriate.

-- 
	Evgeniy Polyakov
