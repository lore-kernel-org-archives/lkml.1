Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbZBPXCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbZBPXCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZBPXCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:02:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57889 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZBPXCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:02:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [RFD] Automatic suspend
Date: Tue, 17 Feb 2009 00:00:41 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Arve Hj?nnev?g" <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902160010.16955.rjw@sisk.pl> <200902162248.34287.rjw@sisk.pl> <20090216225116.GG1370@ucw.cz>
In-Reply-To: <20090216225116.GG1370@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170000.43387.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009, Pavel Machek wrote:
> Hi!
> 
> > > Userland should never ever control the state of a device like this
> > > directly. It should do so by a) closing the device and b) setting
> > > latency / functional requirements.
> > 
> > The user, however, may want to forcibly put a device into a low power state
> > without stopping all of the applications that depend on it (eg. have it open).
> > Do you think that we shouldn't allow users to do such things?
> 
> I don't think we should do this... of you want device to be powered
> down, just don't keep it open. revoke should be enough :-).
> 
> ...one execption here is the disk driver; unmounting filesystems to
> let the disk spin down is probably too heavy.

Well, I don't think it's viable to make any exceptions here.  Either we do it
or we don't.  And the agreement appears to be that we don't.

Thanks,
Rafael
