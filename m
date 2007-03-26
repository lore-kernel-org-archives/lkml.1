Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbXCZM0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbXCZM0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 08:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbXCZM0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 08:26:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbXCZM0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 08:26:12 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0703261512120.13921@sbz-30.cs.Helsinki.FI> 
References: <Pine.LNX.4.64.0703261512120.13921@sbz-30.cs.Helsinki.FI> 
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       bryan.wu@analog.com, alan@lxorguk.ukuu.org.uk
Subject: Re: revoke: no revoke for nommu 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 26 Mar 2007 13:25:59 +0100
Message-ID: <11139.1174911959@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> There's just no sane way to revoke shared memory mappings for NOMMU so lets
> disable the thing completely when CONFIG_MMU=n.

I think that's reasonable for now - we can always add support as far as
possible later.

David
