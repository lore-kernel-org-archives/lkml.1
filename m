Return-Path: <linux-kernel-owner+w=401wt.eu-S1762515AbYBWLhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762515AbYBWLhh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 06:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbYBWLh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 06:37:29 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54172 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYBWLh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 06:37:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 23 Feb 2008 12:36:33 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/2] firewire: endianess fix
To: linux1394-devel@lists.sourceforge.net
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Kristian Hoegsberg <krh@bitplanet.net>,
       Jarod Wilson <jwilson@redhat.com>
In-Reply-To: <tkrat.9e19fa31951506af@s5r6.in-berlin.de>
Message-ID: <tkrat.e867721c03e156c2@s5r6.in-berlin.de>
References: <20080220220326.GA22328@uranus.ravnborg.org>
 <1203545913.25307.47.camel@brick> <tkrat.e2bfb30f2c0ae70a@s5r6.in-berlin.de>
 <tkrat.9e19fa31951506af@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> If possible, also test whether the device remains accessible after
> forcing a bus reset, e.g. by "echo br short > firecontrol".

"echo br short | firecontrol" of course.

This test should actually not really be necessary because simply
plugging the SBP-2 device in should already cause enough generation
changes for the code to trip over an endianess bug before or after thhe
patch, me thinks.
-- 
Stefan Richter
-=====-==--- --=- =-===
http://arcgraph.de/sr/

