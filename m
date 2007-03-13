Return-Path: <linux-kernel-owner+w=401wt.eu-S965634AbXCMJUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965634AbXCMJUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965622AbXCMJUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:20:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47554 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965635AbXCMJUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:20:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@redhat.com>
Subject: Re: 2.6.21rc suspend to ram regression on Lenovo X60
Date: Tue, 13 Mar 2007 10:22:53 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <20070313040828.GA17893@redhat.com>
In-Reply-To: <20070313040828.GA17893@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703131022.54322.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 13 March 2007 05:08, Dave Jones wrote:
> I spent considerable time over the last day or so bisecting to
> find out why an X60 stopped resuming somewhen between 2.6.20 and current -git.
> (Total lockup, black screen of death).

Do you have CONFIG_TICK_ONESHOT or CONFIG_NO_HZ set?  If you do, could you
please unset them and retest?

Thanks,
Rafael
