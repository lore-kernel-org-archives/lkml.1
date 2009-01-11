Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbZAKAeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbZAKAeV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 19:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbZAKAdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 19:33:33 -0500
Received: from ozlabs.org ([203.10.76.45]:34349 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbZAKAda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 19:33:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18793.15953.591733.958862@cargo.ozlabs.ibm.com>
Date: Sun, 11 Jan 2009 11:33:21 +1100
From: Paul Mackerras <paulus@samba.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       devel@openvz.org, xemul@openvz.org
Subject: Re: [RFC 4/4] net: ppp_generic - introduce net-namespace
	functionality
In-Reply-To: <20090110092830.GB7622@localhost>
References: <20090109195154.320495476@gmail.com>
	<4967accd.0305560a.3553.ffffd187@mx.google.com>
	<20090110092258.GA7622@localhost>
	<20090110092830.GB7622@localhost>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov writes:

> From: Cyrill Gorcunov <gorcunov@gmail.com>
> Subecjt: [RFC] net: ppp_generic - introduce net-namespace functionality
> 
> - Each namespace contain ppp channels and units separately
>   with appropriate locks

This looks like a lot of uglification to me.  Why exactly do
individual network drivers need to know or care about namespaces?

Paul.
