Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbXDUAeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbXDUAeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 20:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbXDUAeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 20:34:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbXDUAeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 20:34:11 -0400
Date: Fri, 20 Apr 2007 20:33:47 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: "Preston A. Elder" <prez@goth.net>, linux-kernel@vger.kernel.org
Subject: Re: AGPGart / AMD K7
Message-ID: <20070421003347.GA12760@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	"Preston A. Elder" <prez@goth.net>, linux-kernel@vger.kernel.org
References: <46286775.5000507@goth.net> <20070420155537.GA20118@redhat.com> <4628F00B.3010304@goth.net> <20070420173337.GD20118@redhat.com> <462900BD.8020204@goth.net> <20070420182029.GF20118@redhat.com> <20070420182952.GA18930@kroah.com> <20070420190028.GF13939@redhat.com> <20070420232651.GB10949@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420232651.GB10949@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 04:26:51PM -0700, Greg Kroah-Hartman wrote:
 > > We should always have a bus in bus_add_driver()
 > > Instead of returning success when we don't, BUG().
 > 
 > Nah, I don't like adding BUG() calls to the kernel if it can be helped,
 > how about the version I copied you on a few hours ago, which is also
 > below?

Either works for me..

	Dave

-- 
http://www.codemonkey.org.uk
