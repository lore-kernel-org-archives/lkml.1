Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbZFEEkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbZFEEkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZFEEkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:40:40 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:42630 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZFEEkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:40:39 -0400
Subject: Re: [PATCH] - support inheritance of mlocks across fork/exec V2
From: Jon Masters <jonathan@jonmasters.org>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <1228331069.6693.73.camel@lts-notebook>
References: <1227561707.6937.61.camel@lts-notebook>
	 <20081125152651.b4c3c18f.akpm@linux-foundation.org>
	 <1228331069.6693.73.camel@lts-notebook>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Fri, 05 Jun 2009 00:39:17 -0400
Message-Id: <1244176757.11597.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 14:04 -0500, Lee Schermerhorn wrote:

> Add support for mlockall(MCL_INHERIT|MCL_RECURSIVE):

FWIW, I really liked this patch series. And I think there is still value
in a generic "mlock" wrapper utility that I can use. Sure, the later on
containers suggestions are all wonderful in theory but I don't see that
that went anywhere either (and I disagree that we can't trust people to
use this right without doing silly things) - if I'm really right that
this got dropped on the floor, can we resurrect it in .31 please?

Jon.


