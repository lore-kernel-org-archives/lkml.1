Return-Path: <linux-kernel-owner+w=401wt.eu-S932150AbZKXFjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbZKXFjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 00:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbZKXFjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 00:39:41 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59695 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754501AbZKXFjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 00:39:40 -0500
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the
 kernel (__ksymtab)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alex Chiang <achiang@hp.com>, Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Tony Luck <tony.luck@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Mike Frysinger <vapier.adi@gmail.com>, greg@kroah.com,
       linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca, deller@gmx.de,
       jejb@parisc-linux.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org
In-Reply-To: <200911241127.18013.rusty@rustcorp.com.au>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
	 <4B072E31.4000906@tuffmail.co.uk> <20091123195320.GD26810@ldl.fc.hp.com>
	 <200911241127.18013.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 23:39:42 -0600
Message-Id: <1259041182.2433.945.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 11:27 +1030, Rusty Russell wrote:
> On Tue, 24 Nov 2009 06:23:20 am Alex Chiang wrote:
> > Hi Alan, Rusty,
> 
> Hi Alex,
> 
> > In the meantime, while Alan is deciding the proper way to fix
> > this, would it be possible to drop the offending patch series
> > from linux-next?
> 
> Done.  That takes the pressure off Alan, and makes sure he has time to get
> it right.

That probably suits us on parisc too.  I just checked out our build in
linux-next: we don't pass __modpost ... it looks like we have all the
module symbols undefined.  Will investigate more.

James


