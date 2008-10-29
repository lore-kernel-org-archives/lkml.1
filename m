Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbYJ2XXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbYJ2XXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbYJ2XW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:22:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:46702 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbYJ2XW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:22:58 -0400
Date: Wed, 29 Oct 2008 16:23:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       me@bobcopeland.com
Subject: Re: pull request: wireless-2.6 2008-10-29
Message-ID: <20081029162324.28f5864d@infradead.org>
In-Reply-To: <20081029231855.GD3485@tuxdriver.com>
References: <20081029231855.GD3485@tuxdriver.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 19:18:55 -0400
"John W. Linville" <linville@tuxdriver.com> wrote:

> Dave,
> 
> Another quick round of fixes intended for 2.6.28...
> 
> This includes fixes for bugs 11749 and 11845, fixes a reset-related
> regression in ath5k, fixes a Kconfig-related error for rt2x00, and
> fixes some sparse warnings and a possible buffer overrun in libertas.
> Also, it corrects a spelling error and marks Bob Copeland as an
> ath5k maintainer.

speaking of ath5k:

http://www.kerneloops.org/version.php?start=1835008&end=1867775&version=28-rc

it seems to have added a few WARN_ON()s which now end up at the top of
the list .. are these known or should I spend some time writing reports
for netdev ?
