Return-Path: <linux-kernel-owner+w=401wt.eu-S934465AbXHNEa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465AbXHNEa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 00:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbXHNEaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 00:30:03 -0400
Received: from livid.absolutedigital.net ([66.92.46.173]:35147 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbXHNEaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 00:30:00 -0400
Date: Tue, 14 Aug 2007 00:29:09 -0400 (EDT)
From: Cal Peake <cp@absolutedigital.net>
To: Joe Perches <joe@perches.com>
cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Eng.Linux@digi.com
Subject: Re: [PATCH] [154/2many] MAINTAINERS - DIGI INTL. EPCA DRIVER
In-Reply-To: <1187064798.32555.7.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708140021460.11945@lancer.cnet.absolutedigital.net>
References: <46bff988.qGtTTlNorD2He7J3%joe@perches.com> 
 <20070813115344.04759b74@the-village.bc.nu>  <46C06E70.9090905@s5r6.in-berlin.de>
  <46C0838A.2030504@intel.com>  <1187022904.10249.97.camel@localhost>
 <1187064798.32555.7.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Joe Perches wrote:

> On Mon, 2007-08-13 at 09:35 -0700, Joe Perches wrote:
> > On Mon, 2007-08-13 at 09:15 -0700, Kok, Auke wrote:
> > > or properly put it on "quotes":
> > 
> > I'll improve the script and revert the name changes.
> 
> # check for "must quote" chars in name
> 
> sub format_email {
>     my ($name, $email) = @_;
> 
>     if ($name =~ tr@,\@<>@@) {
> 	$formatted_email = "\"${name}\"\ \<${email}\>";
>     } else {
> 	$formatted_email = "${name} \<${email}\>";
>     }
>     return $formatted_email;
> }
> 
> Anyone know what chars require the name be quoted?
> I've got: "," "@" "<" ">" ?

Prolly /[^a-z0-9]/i would the safest bet. Also don't forget to escape 
double quotes (e.g. "Jonathan \"Jon\" Doe" <jon@example.net>).

Cheers,
-- 
Cal Peake

