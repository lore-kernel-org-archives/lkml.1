Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYHSPZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYHSPZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYHSPZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:25:05 -0400
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:44056
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752664AbYHSPZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:25:04 -0400
Date: Tue, 19 Aug 2008 08:25:04 -0700
From: Phil Oester <kernel@linuxace.com>
To: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iptables-1.4.0 with 2.6.26
Message-ID: <20080819152504.GA13246@linuxace.com>
References: <48AAAFEB.8020608@cetrtapot.si> <20080819140601.GA5135@linuxace.com> <48AAD48E.3030409@cetrtapot.si>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AAD48E.3030409@cetrtapot.si>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 04:11:26PM +0200, Hinko Kocevar wrote:
> Well, it builds.
> But trying to add simple rule fails:
> 
> hinkok@alala /tmp/iptables-1.4.1.1 $ sudo ./iptables -A INPUT -p tcp --dport 80 -j DROP
> iptables v1.4.1.1: Unknown arg `--dport'
> Try `iptables -h' or 'iptables --help' for more information.

Yes, that wouldn't work unless you built a static iptables binary (--enable-static).
Please run make install, then it will work for you from the install directory.

Phil
