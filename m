Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbYASSmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbYASSmO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 13:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYASSl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 13:41:59 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:20597 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbYASSl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 13:41:58 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: pnpacpi : exceeded the max number of IO resources
Date: Sat, 19 Jan 2008 11:38:53 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Dave Young <hidave.darkstar@gmail.com>, akpm@osdl.org,
       cholvenstot@comcast.net, lenb@kernel.org, linux-kernel@vger.kernel.org,
       rene.herman@keyaccess.nl, shaohua.li@intel.com, trenn@suse.de,
       yakui.zhao@intel.com
References: <1196428488.7066.6.camel@localhost> <a8e1da0801152155x18cfd0dcvfe638323275e539d@mail.gmail.com> <E1JGBUB-0003HA-1e@faramir.fjphome.nl>
In-Reply-To: <E1JGBUB-0003HA-1e@faramir.fjphome.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801191138.54978.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2008 4:03:39 am Frans Pop wrote:
> Dave Young wrote:
> > I noticed the port number changed to 40 in 2.6.24-rc8, but it's not
> > enough for me still.
>
> Same here, though the extreme noise has gone.
> From /proc/ioports and dmesg it looks like I'm short by either 1, or 3 :-(

Yup.  It should be no worse than in 2.6.23, where we silently ignored
excess resources.  We plan to fix it for real in 2.6.25.
