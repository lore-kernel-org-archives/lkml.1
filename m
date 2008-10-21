Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbYJUFNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbYJUFNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 01:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYJUFNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 01:13:13 -0400
Received: from 1wt.eu ([62.212.114.60]:4863 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbYJUFNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 01:13:13 -0400
Date: Tue, 21 Oct 2008 07:12:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: Nicolas Cannasse <ncannasse@motion-twin.com>
Cc: davids@webmaster.com, swivel@shells.gnugeneration.com,
       linux-kernel@vger.kernel.org
Subject: Re: poll() blocked / packets not received ?
Message-ID: <20081021051252.GS24654@1wt.eu>
References: <MDEHLPKNGKAHNMBLJOLKAEJCAIAD.davids@webmaster.com> <48FCBEBE.700@motion-twin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FCBEBE.700@motion-twin.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 07:24:14PM +0200, Nicolas Cannasse wrote:
> For (1) I can't add the timeout since I have no way to differentiate 
> between a lost connection and a request that takes time to execute.

Not only you can, but you *must*. Any service assuming infinite timeout
is deemed to fail. If you know that one request can take as long as one
minute for instance, then use a 2 minutes timeout. The day all requests
will be automatically cleaned up because of a failed firewall between
client and server, you'll be happy not to have to come there and restart
the service to flush them.

There's a huge difference between using a very large timeout and none at
all.

Willy

