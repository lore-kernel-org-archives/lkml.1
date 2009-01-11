Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbZAKHjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbZAKHjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 02:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZAKHjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 02:39:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38397
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbZAKHjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 02:39:12 -0500
Date: Sat, 10 Jan 2009 23:39:12 -0800 (PST)
Message-Id: <20090110.233912.19825434.davem@davemloft.net>
To: paulus@samba.org
Cc: gorcunov@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       devel@openvz.org, xemul@openvz.org
Subject: Re: [RFC 4/4] net: ppp_generic - introduce net-namespace
 functionality
From: David Miller <davem@davemloft.net>
In-Reply-To: <18793.15953.591733.958862@cargo.ozlabs.ibm.com>
References: <20090110092258.GA7622@localhost>
	<20090110092830.GB7622@localhost>
	<18793.15953.591733.958862@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Sun, 11 Jan 2009 11:33:21 +1100

> Cyrill Gorcunov writes:
> 
> > From: Cyrill Gorcunov <gorcunov@gmail.com>
> > Subecjt: [RFC] net: ppp_generic - introduce net-namespace functionality
> > 
> > - Each namespace contain ppp channels and units separately
> >   with appropriate locks
> 
> This looks like a lot of uglification to me.  Why exactly do
> individual network drivers need to know or care about namespaces?

They need to know if there is a lookup involved and the device
type internally has it's own realm of keys that identify such
devices.

PPP fits that particular case.
