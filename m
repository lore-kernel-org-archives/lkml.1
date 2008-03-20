Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbYCTO2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbYCTO2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 10:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbYCTO2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 10:28:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbYCTO2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 10:28:21 -0400
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Len Brown <lenb@kernel.org>
Cc: =?ISO-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tilman Schmidt <tilman@imap.cc>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <200803181632.44288.lenb@kernel.org>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <200803171327.16695.lenb@kernel.org>
	 <1205858252.21619.233.camel@queen.suse.de>
	 <200803181632.44288.lenb@kernel.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 20 Mar 2008 15:28:19 +0100
Message-Id: <1206023299.21619.358.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-18 at 16:32 -0400, Len Brown wrote:
> > > The initrd version of the DSDT override is really for one scenario.
> > > Somebody who has a BIOS that even Windows can't deal with -- so
> > > no amount of "Windows bug compatbility" will help Linux with it.
> 
> > No, this is for people getting involved in ACPI.
> > Everybody thinks ACPI is that complicated..., but it's not.
> > It's amazing how far people can debug ACPI bugs (yes, even people who
> > "do not even know" how to compile a kernel) by simply analyzing the ASL
> > BIOS code.
> 
> Thomas,
> The justification above is what convinced me
> that we should try to integrate this feature.
> Further, although we failed in 2.6.25,
> I think we should continue to try to get this capability integrated.
> 
> If you think it will be useful for additional purposes, that's great.
> As you know, I'm somewhat skeptical, as I've seen huge mistakes such
> as a database of modified BIOS images created and used when the users
> have absolutely no idea what they're doing.
But even here we now have the only existing database for some research.
-> very important IMO.
> But we don't have to
> agree on this to move forward.
I think we fully agree.
I don't mind to add a message in big letters: "Only override the DSDT
for debugging, please report any findings" or whatever, we can add this
ten times in a row, still it is an important feature which is worth
pushing (and getting populate_root_fs being able to be executed earlier
is a feature others also like to see AFAIK).

    Thomas

