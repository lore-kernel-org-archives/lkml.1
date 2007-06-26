Return-Path: <linux-kernel-owner+w=401wt.eu-S1763053AbXFZXch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763053AbXFZXch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759914AbXFZXc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:32:27 -0400
Received: from v035086.ppp.asahi-net.or.jp ([124.155.35.86]:7509 "HELO
	daikokuya.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1759232AbXFZXcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:32:25 -0400
Date: Wed, 27 Jun 2007 08:32:26 +0900
From: Neil Booth <neil@daikokuya.co.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070626233226.GO7590@daikokuya.co.uk>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626221134.GA21350@ftp.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:-

> Hopefully correct handling of integer constant expressions.  Please, review.

Am I invoking sparse wrongly?  ./sparse -W -Wall doesn't diagnose
the following TU, for example.

extern int a;
extern int as1[(a = 2)];

Neil.
