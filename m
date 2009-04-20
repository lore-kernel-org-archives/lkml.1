Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbZDTJzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbZDTJzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 05:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZDTJza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 05:55:30 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:2006 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751473AbZDTJz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:55:29 -0400
Message-ID: <49EC4683.3060605@myri.com>
Date: Mon, 20 Apr 2009 11:55:15 +0200
From: Brice Goglin <brice@myri.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: David Dillow <dave@thedillows.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux Network Development list <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] myri10ge: allow per-board firmware overriding
References: <49E7239B.4000309@myri.com>	<20090417095038.49b745bf@dhcp-lab-109.englab.brq.redhat.com>	<49EA1DAC.1000602@myri.com>	<1240102617.5342.6.camel@obelisk.thedillows.org>	<1240108599.5342.11.camel@obelisk.thedillows.org> <20090420114041.37c7fa7b@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20090420114041.37c7fa7b@dhcp-lab-109.englab.brq.redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislaw Gruszka wrote:
> Providing module_param_id would address this issues, but I have some concerns
> before doing it:
>
> - device have to access ID (like serial no) before initialization (at least
>   before driver will need parameter)
> - why nobody already done it - perhaps such thing would be totally useless
>   

Per-nic module parameters are used in some Intel NIC drivers but it's
not considered a very good solution in the general case:
   
http://kerneltrap.org/index.php?q=mailarchive/linux-netdev/2008/10/24/3801824/thread

But again, when talking about changing the NIC firmware, ethtool and
friends are not that easy.

Brice

