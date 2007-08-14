Return-Path: <linux-kernel-owner+w=401wt.eu-S1763550AbXHNEOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763550AbXHNEOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 00:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbXHNEON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 00:14:13 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4067 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbXHNEOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 00:14:12 -0400
Subject: Re: [PATCH] [154/2many] MAINTAINERS - DIGI INTL. EPCA DRIVER
From: Joe Perches <joe@perches.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Eng.Linux@digi.com
In-Reply-To: <1187022904.10249.97.camel@localhost>
References: <46bff988.qGtTTlNorD2He7J3%joe@perches.com>
	 <20070813115344.04759b74@the-village.bc.nu>
	 <46C06E70.9090905@s5r6.in-berlin.de>  <46C0838A.2030504@intel.com>
	 <1187022904.10249.97.camel@localhost>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 21:13:18 -0700
Message-Id: <1187064798.32555.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 09:35 -0700, Joe Perches wrote:
> On Mon, 2007-08-13 at 09:15 -0700, Kok, Auke wrote:
> > or properly put it on "quotes":
> 
> I'll improve the script and revert the name changes.

# check for "must quote" chars in name

sub format_email {
    my ($name, $email) = @_;

    if ($name =~ tr@,\@<>@@) {
	$formatted_email = "\"${name}\"\ \<${email}\>";
    } else {
	$formatted_email = "${name} \<${email}\>";
    }
    return $formatted_email;
}

Anyone know what chars require the name be quoted?
I've got: "," "@" "<" ">" ?

