Return-Path: <linux-kernel-owner+w=401wt.eu-S1761372AbYDAVWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761372AbYDAVWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbYDAVWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:22:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48581 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbYDAVWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:22:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Didier Raboud <didier@raboud.com>
Subject: Re: =?iso-8859-15?q?2=2E6=2E25-rc7=A0=3A_hibernation_sometimes_not_resuming_on?=
 =?iso-8859-15?q?_Dell_Latitude?= D630
Date: Tue, 1 Apr 2008 23:22:35 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
References: <200803311823.36693.didier@raboud.com> <200804012311.16076.rjw@sisk.pl> <200804012318.26002.didier@raboud.com>
In-Reply-To: <200804012318.26002.didier@raboud.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804012322.35672.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of April 2008, Didier Raboud wrote:
> Le mardi, 1 avril 2008 23.11:15 Rafael J. Wysocki, vous avez écrit :
> > (...)
> > Can you please test the in-kernel hibernation, then?
> >
> > Rafael
> 
> Hi,
> 
> would like to. How ? 
> 
> # echo -n disk > /sys/power/state 

Yes, should work without the "-n", too.  Of course, you have to use the
'resume=' kernel command line argument for this to work.

Perhaps increase the console log level before that.

Thanks,
Rafael
