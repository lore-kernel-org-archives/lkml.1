Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYGICbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYGICbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 22:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYGICbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 22:31:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37850 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752132AbYGICbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 22:31:34 -0400
Date: Tue, 8 Jul 2008 21:31:31 -0500
From: Paul Jackson <pj@sgi.com>
To: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Cc: "Bryan O'Sullivan" <bos@serpentine.com>
Subject: LKML mercurial repository borked
Message-Id: <20080708213131.1afb7314.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lkml mercurial (hg) repository at:

  http://www.kernel.org/hg/linux-2.6

is borked.

Trying to "hg pull" from it fails quickly, with:

  pulling from http://www.kernel.org/hg/linux-2.6
  abort: 'http://www.kernel.org/hg/linux-2.6' does not appear to be an hg repository!

Going to 'http://www.kernel.org/hg/linux-2.6' with a web browser fills
ones browser screen with a RevlogError from some Python script.

The backdoor http://master.kernel.org/hg/linux-2.6 still works,
so my local configuration and installation of python and mercurial
is apparently not messed up.  However we are not supposed to use
that backdoor normally, as it has much less bandwidth (to quote
a two year old message I have from Bryan, the last time something
like this happened.)

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
