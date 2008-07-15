Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbYGOXMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbYGOXMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbYGOXL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:11:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbYGOXL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:11:57 -0400
Date: Tue, 15 Jul 2008 19:04:46 -0400
From: Dave Jones <davej@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Marcel Holtmann <marcel@holtmann.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
Message-ID: <20080715230446.GD10532@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Frans Pop <elendil@planet.nl>, jeff@garzik.org, arjan@infradead.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	linux-kernel@vger.kernel.org
References: <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <200807151757.10626.elendil@planet.nl> <1216149637.27242.65.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org> <1216150616.27455.377.camel@shinybook.infradead.org> <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org> <1216151866.26991.4.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216151866.26991.4.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 12:57:46PM -0700, David Woodhouse wrote:
 > On Tue, 2008-07-15 at 12:49 -0700, Linus Torvalds wrote:
 > > So kernel-specific directories do make sense. As does the whole "I
 > > don't want to handle the pain that is udev scripts".
 > 
 > I'm not violently opposed to kernel-specific directories. Ubuntu does it
 > that way already, and it may well make sense. I'm not sure it's really
 > necessary either, but it's an option.

Some of the wireless drivers have an issue where firmware x works with
driver y, so it's useful for that case even if nothing else uses it.

	Dave

-- 
http://www.codemonkey.org.uk
