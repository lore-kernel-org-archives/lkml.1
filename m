Return-Path: <linux-kernel-owner+w=401wt.eu-S1762284AbZANMZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284AbZANMZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 07:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbZANMZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 07:25:44 -0500
Received: from hosting.visp.net.lb ([194.146.153.11]:58099 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbZANMZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 07:25:41 -0500
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2009 07:25:41 EST
From: Denys Fedoryschenko <denys@visp.net.lb>
Organization: VISP
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: deadlocks if use htb
Date: Wed, 14 Jan 2009 14:17:58 +0200
User-Agent: KMail/1.9.9
Cc: Chris Caputo <ccaputo@alt.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Badalian Vyacheslav <slavon@bigtelecom.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20081010090426.GA6054@ff.dom.local> <Pine.LNX.4.64.0901110438050.16453@nacho.alt.net> <20090114063909.GA4234@ff.dom.local>
In-Reply-To: <20090114063909.GA4234@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141417.58667.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will try that patches too, when i got this message, after 3 minutes i got 
crash of my router :-) after working around 17 hours :-(
There is 3 of them by the way, 2 fixes also.

hrtimer: removing all ur callback modes
hrtimer: removing all ur callback modes, fix hotplug
hrtimer: removing all ur callback modes, fix

On Wednesday 14 January 2009 08:39:09 Jarek Poplawski wrote:
> On Wed, Jan 14, 2009 at 02:43:13AM +0000, Chris Caputo wrote:
> ...
>
> > Per Jarek's suggestion in bugzilla, I ran 2.6.28 plus Peter Zijlstra's
> > "hrtimer: removing all ur callback modes" patches dated 2008-11-25,
> > 2008-12-04 and 2008-12-08.  Uptime was 2 days 22 hours before I hit what
> > appears to be an unrelated bug related to the IPv6 FIB.  (Separately
> > reported with subject 'panic with 2.6.28 while doing "ip -6 route"'.)
>
> Chris, this is a very good news, thanks for testing this!
>
> Peter, great work! IMHO these patches should go to the stable (at
> least 2.6.28).
>
> Thanks,
> Jarek P.


