Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbXF0MK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbXF0MK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXF0MKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:10:18 -0400
Received: from v035086.ppp.asahi-net.or.jp ([124.155.35.86]:7549 "HELO
	daikokuya.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755441AbXF0MKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:10:16 -0400
Date: Wed, 27 Jun 2007 21:10:21 +0900
From: Neil Booth <neil@daikokuya.co.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070627121021.GQ7590@daikokuya.co.uk>
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

Here are three independently invalid non-ICEs that sparse doesn't
diagnose.

extern int f(void);
enum { cast_to_ptr = (int) (void *) 0 };
enum { cast_to_float = (int) (double) 1 };
enum { fncall = 0 ? f(): 3 };

Hey, I did warn you it was tricky :)

Neil.
