Return-Path: <linux-kernel-owner+w=401wt.eu-S1760376AbZJILYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760376AbZJILYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 07:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbZJILYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 07:24:05 -0400
Received: from mail.perches.com ([173.55.12.10]:2018 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbZJILYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 07:24:05 -0400
Subject: Re: [RFC] scripts/get_maintainer: add emails based on keywords in
 the patch
From: Joe Perches <joe@perches.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       devicetree-discuss@ozlabs.org, Grant Likely <grant.likely@secretlab.ca>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <1255084379-12954-1-git-send-email-w.sang@pengutronix.de>
References: <1255084379-12954-1-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Oct 2009 04:23:26 -0700
Message-Id: <1255087406.16347.108.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 12:32 +0200, Wolfram Sang wrote:

> +my %keywords_to_mail = (
> +	'of_get_property' => 'L: devicetree-discuss@lists.ozlabs.org',

maybe: '\bof_get_property\b'

> +	    # Check the lines which a patch modifies for keywords; add mail if found.
> +	    } elsif (m/^[+-].*($keywords_to_mail_match)/o) {
> +		(my $keyword_mail = $keywords_to_mail{$1}) =~ s/^([LM]): //;
> +		push( @{ ($1 eq 'L') ? \@list_to : \@email_to }, $keyword_mail );
> +	   }

If this facility is desired by many others, it might be
better to have a separate file of 'regex generates email'
read at initialization.


