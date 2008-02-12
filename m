Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbYBLT2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYBLT2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbYBLT2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:28:20 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60956 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbYBLT2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:28:19 -0500
Subject: Re: [PATCH] enclosure: add support for enclosure services
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: kristen.c.accardi@intel.com
Cc: ltuikov@yahoo.com, linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org
In-Reply-To: <20080212110752.21840627@appleyard>
References: <1202172065.3096.154.camel@localhost.localdomain>
	 <922945.25870.qm@web31811.mail.mud.yahoo.com>
	 <20080212102244.32869382@appleyard>
	 <1202841935.3137.94.camel@localhost.localdomain>
	 <20080212110752.21840627@appleyard>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 13:28:15 -0600
Message-Id: <1202844495.3137.120.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 11:07 -0800, Kristen Carlson Accardi wrote:
> I understand what you are trying to do - I guess I just doubt the value
> you've added by doing this.  I think that there's going to be so much
> customization that system vendors will want to add, that they are going
> to wind up adding a custom library regardless, so standardising those
> few things won't buy us anything.

It depends ... if you actually have a use for the customisations, yes.
If you just want the basics of who (what's in the enclousure), what
(activity) and where (locate) then I think it solves your problem almost
entirely.

So, entirely as a straw horse, tell me what else your enclosures provide
that I haven't listed in the four points.  The SES standards too provide
a huge range of things that no-one ever seems to implement (temperature,
power, fan speeds etc).

I think the users of enclosures fall int these categories

85% just want to know where their device actually is (i.e. that sdc is
in enclosure slot 5)
50% like watching the activity lights
30% want to be able to have a visual locate function
20% want a visual failure indication (the other 80% rely on some OS
notification instead)

When you add up the overlapping needs, you get about 90% of people happy
with the basics that the enclosure services provide.  Could there be
more ... sure; should there be more ... I don't think so ... that's what
value add the user libraries can provide.

James


