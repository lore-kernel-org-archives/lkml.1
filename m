Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbYJ1Fsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbYJ1Fsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 01:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYJ1Fsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 01:48:36 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1942 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbYJ1Fsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 01:48:36 -0400
Subject: Re: [RFC PATCH 3/5] net/ipv4, net/ipv6: use %#p6, %p6 format
 strings
From: Joe Perches <joe@perches.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Miller <davem@davemloft.net>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1225172104.5526.28.camel@brick>
References: <1225166718.5526.18.camel@brick>
	 <1225170338.5269.127.camel@localhost>  <1225172104.5526.28.camel@brick>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 22:47:56 -0700
Message-Id: <1225172877.5269.139.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0-2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 22:35 -0700, Harvey Harrison wrote:
> I thought about this, and it will work if the one place that passes
> NIP6_FMT into sscanf gets changed at the same time.  Otherwise,
> doing it in-place is probably safer.

Maybe sscanf should be updated to support these new %p<foo> types.

