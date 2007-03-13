Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbXCMNWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbXCMNWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 09:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbXCMNWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 09:22:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbXCMNWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 09:22:47 -0400
Date: Tue, 13 Mar 2007 09:22:18 -0400
From: Dave Jones <davej@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21rc suspend to ram regression on Lenovo X60
Message-ID: <20070313132218.GA25910@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <20070313040828.GA17893@redhat.com> <200703131022.54322.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703131022.54322.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 10:22:53AM +0100, Rafael J. Wysocki wrote:
 > On Tuesday, 13 March 2007 05:08, Dave Jones wrote:
 > > I spent considerable time over the last day or so bisecting to
 > > find out why an X60 stopped resuming somewhen between 2.6.20 and current -git.
 > > (Total lockup, black screen of death).
 > 
 > Do you have CONFIG_TICK_ONESHOT or CONFIG_NO_HZ set?  If you do, could you
 > please unset them and retest?

I did try with NO_HZ unset, made no difference, I don't recall TICK_ONESHOT.
I'm in meetings all day, but I'll check when I get home.

	Dave

-- 
http://www.codemonkey.org.uk
