Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYGDW13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYGDW13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 18:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYGDW1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 18:27:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbYGDW1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 18:27:19 -0400
Date: Fri, 4 Jul 2008 18:20:16 -0400
From: Dave Jones <davej@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
       gregkh@suse.de
Subject: Re: usb-storage: quirk around v1.11 firmware on Nikon D4
Message-ID: <20080704222015.GA9792@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-usb@vger.kernel.org, gregkh@suse.de
References: <20080704195940.GA17510@redhat.com> <Pine.LNX.4.44L0.0807041808100.17654-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0807041808100.17654-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 06:09:25PM -0400, Alan Stern wrote:
 > On Fri, 4 Jul 2008, Dave Jones wrote:
 > 
 > > usb-storage: quirk around v1.11 firmware on Nikon D40
 > ...
 > > -UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0110,
 > > +UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0111,
 > >  		"NIKON",
 > >  		"NIKON DSC D80",
 > 
 > You updated the entry for the D80, not the D40.

argh.

 >  Maybe they both need to be updated?

Maybe. I'm not familiar with how similar the firmware is between
those two cameras.  The version numbering would certainly suggest that
is the case, but should we take a chance and guess, or wait
until a user complains?

	Dave

-- 
http://www.codemonkey.org.uk
