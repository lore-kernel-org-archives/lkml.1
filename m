Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZGVK0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZGVK0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZGVK0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:26:39 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:37473 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZGVK0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:26:39 -0400
Date: Wed, 22 Jul 2009 11:27:08 +0100 (BST)
From: Troy Moure <twmoure@szypr.net>
To: Jens Rosenboom <jens@leia.mcbone.net>
cc: Krzysztof Oledzki <olel@ans.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Troy Moure <twmoure@szypr.net>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net, Ian Lance Taylor <iant@google.com>
Subject: Re: Linux 2.6.27.27
In-Reply-To: <1248256689.7237.2.camel@fnki-nb00130>
Message-ID: <alpine.LFD.2.00.0907221124490.11527@troy-laptop>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl>  <20090720151008.GC10015@suse.de>  <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain>  <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl>  <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
  <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl>  <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl>  <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain>  <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain> 
 <alpine.LFD.2.00.0907212211040.4630@troy-laptop>  <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain>  <alpine.LFD.2.01.0907211811410.19335@localhost.localdomain>  <alpine.LNX.1.10.0907220914150.26357@bizon.gios.gov.pl> 
 <alpine.LNX.1.10.0907221022380.26357@bizon.gios.gov.pl> <1248256689.7237.2.camel@fnki-nb00130>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Jul 2009, Jens Rosenboom wrote:

> > >> --- a/drivers/video/fbmon.c
> > >> +++ b/drivers/video/fbmon.c
> > >> @@ -256,8 +256,8 @@ static void fix_edid(unsigned char *edid, int fix)
> > >> 
> > >> static int edid_checksum(unsigned char *edid)
> > >> {
> > >> -	unsigned char i, csum = 0, all_null = 0;
> > >> -	int err = 0, fix = check_edid(edid);
> > >> +	unsigned csum = 0, all_null = 0;
> 
> I guess Linus shouldn't have deleted the "char" here...
> 
> [...]
> 

Doh! I missed this - I didn't look closely at his patch.

You can disregard my just-sent message, then...

	Troy

