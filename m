Return-Path: <linux-kernel-owner+w=401wt.eu-S1761918AbXGDPD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918AbXGDPD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 11:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbXGDPDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 11:03:20 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:52480 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbXGDPDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 11:03:19 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 17:03:21 +0200
User-Agent: KMail/1.9.7
Cc: rjw@sisk.pl, paulus@samba.org, mjg59@srcf.ucam.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070703211227.GA28758@srcf.ucam.org> <200707041641.58883.rjw@sisk.pl> <E1I666o-0006wu-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I666o-0006wu-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707041703.21808.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 4. Juli 2007 schrieb Miklos Szeredi:
> > > And we won't know if drivers are OK until we remove the freezer,
> > > catch-22.
> > 
> > I disagree.  We can learn that by auditing the drivers.
> 
> In theory, yes.  But it scales far worse than letting everyone
> experiment/report/fix problems as they crop up.

You will open many but small races. This would be very painfull
to debug.

	Regards
		Oliver

