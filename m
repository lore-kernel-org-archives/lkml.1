Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbXJQGZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbXJQGZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 02:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXJQGZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 02:25:21 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45495 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbXJQGZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 02:25:20 -0400
X-Sasl-enc: zX0YJ9zcINsoDiAv+OVacD3yvLBKOVi3pClGAZ4PUQWk 1192602318
Date: Wed, 17 Oct 2007 04:25:15 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Message-ID: <20071017062515.GA8588@khazad-dum.debian.net>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <200710160149.56649.jesse.barnes@intel.com> <20071016091857.GD15293@khazad-dum.debian.net> <200710161940.05785.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710161940.05785.jesse.barnes@intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, Jesse Barnes wrote:
> > Last time the issue was brought up (and I do believe it was because
> > of thinkpad-acpi :-) ), he made it clear that any events you are to
> > act upon are fine in input, but events that are just notifications
> > (i.e. the firmware already did the action) are not.
> 
> Ah yeah, I agree with that.  Regular events should be uevents or 
> something, not input events.  Actual keyboard keys though (whether they 
> generate firmware event messages or actual scancodes) should probably 
> go through the input layer.  I thought that's what Jeremy's patch was 
> doing, maybe I didn't look closely enough.

The patch adds keycodes for "keys" that are acually notifications on many
thinkpads.  And that is the problem, please refer to the rest of the thread
for more details...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
