Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbXIVIeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbXIVIeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 04:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbXIVIeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 04:34:07 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:8388 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbXIVIeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 04:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=CgrLfFvJlrnedAbQO+yiFJwuJ8IPhM7yV0azf2bSLrUyFrCYzlUy/jfk6t/VClqychlWQ48laN5kzisz8fBg4LBE3mdYCfl+lqKgFMMnNL99+Gyc7TDzE/A5tI9XPKnl6k0cxU+UQcTDWKxUU318mPKiUAfqUSadIufsiRDCzC0=
Date: Sat, 22 Sep 2007 12:33:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: memset as memzero
Message-ID: <20070922083355.GA7226@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

could anyone tell me why there is no official memzero function (or macros) in
the kernel. As I see a lot of  kernel parts calls for it (defying own macros
as alias to memset). Maybe there is a special reason not to do so? Actually
my suggestion is to define _one_ general macros for this.

		Cyrill

