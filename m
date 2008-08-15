Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYHRPw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYHRPw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 11:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYHRPws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 11:52:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47838 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbYHRPwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 11:52:47 -0400
Date: Fri, 15 Aug 2008 16:34:17 -0400
From: Dave Jones <davej@redhat.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: PM_TRACE is no longer experimental
Message-ID: <20080815203417.GA3012@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Tilman Schmidt <tilman@imap.cc>, Pavel Machek <pavel@suse.cz>,
	Andrew Morton <akpm@osdl.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Trivial patch monkey <trivial@kernel.org>
References: <20080814151833.GA23300@elf.ucw.cz> <48A5B8C8.6040504@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A5B8C8.6040504@imap.cc>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 07:11:36PM +0200, Tilman Schmidt wrote:
 > On 14.08.2008 17:18 Pavel Machek wrote:
 > > PM_TRACE is stable for quite long. I don't think it needs to depend on
 > > experimental.
 > 
 > It might be stable, but its effect of trashing the RTC makes it unsuitable
 > for non-experimental use. Therefore I'd prefer the dependency be kept.

It only does that if you boot with command line options to enable it.
Besides, CONFIG_EXPERIMENTAL was always about code maturity, not a
safety net for people who don't read the descriptions.

Pavels change makes sense to me.

	Dave

-- 
http://www.codemonkey.org.uk
