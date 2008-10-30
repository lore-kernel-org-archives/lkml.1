Return-Path: <linux-kernel-owner+w=401wt.eu-S1756421AbYJ3Pqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbYJ3Pqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYJ3Pqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:46:45 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:36407 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbYJ3Pqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:46:44 -0400
Date: Thu, 30 Oct 2008 16:46:35 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: s390: struct device - replace bus_id with dev_name(),
	dev_set_name()
Message-ID: <20081030154635.GB3871@osiris.boeblingen.de.ibm.com>
References: <1225328227.5970.51.camel@nga.site> <20081030103200.438576a1@gondolin> <20081030113831.GA3871@osiris.boeblingen.de.ibm.com> <ac3eb2510810300758yf0df0e8j43875dd7c98a56c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510810300758yf0df0e8j43875dd7c98a56c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 03:58:21PM +0100, Kay Sievers wrote:
> On Thu, Oct 30, 2008 at 12:38, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > On Thu, Oct 30, 2008 at 10:32:00AM +0100, Cornelia Huck wrote:
> >> On Thu, 30 Oct 2008 01:57:07 +0100,
> >> Kay Sievers <kay.sievers@vrfy.org> wrote:
> >>
> >> > From: Kay Sievers <kay.sievers@vrfy.org>
> >> > Subject: s390: struct device - replace bus_id with dev_name(), dev_set_name()
> >> >
> >> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> >> > Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
> >> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> >> > Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
> >>
> >> Other than the fact that this patch is a bit mis-named (it just gets
> >> rid of BUS_ID_SIZE), this looks fine to me.
> 
> Yeah, sorry, it's one of the 49 patches, where the subjects isn't
> right, because you did the conversion already. :)
> 
> > Who is supposed to send this upstream and when?
> 
> Would be fine if it goes through the s390 tree, and gets merged there
> soon so it shows up in -next.

Just to get this right: it doesn't depend on any other patches and is
fine as a standalone patch, right?
Sorry, this isn't obvious for me ;)
