Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbZD1Sdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbZD1Sdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756685AbZD1Sd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:33:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:59046 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756122AbZD1Sd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:33:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19O70lNRNVOIzQKzs8WScb5AVHbCbz9J43tXA4sSB
	s6g3dzFPQxK/Qt
Subject: Re: [PATCH RFC] ext3 data=guarded v5
From: Mike Galbraith <efault@gmx.de>
To: Chris Mason <chris.mason@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
In-Reply-To: <1240941840.15136.44.camel@think.oraclecorp.com>
References: <1240941840.15136.44.camel@think.oraclecorp.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 20:33:02 +0200
Message-Id: <1240943582.5611.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 14:04 -0400, Chris Mason wrote:

> This patch adds the delayed i_size update to ext3, along with a new
> mount option (data=guarded) to enable it.

Is there a good reason to require a new mount option for this vs just
calling it a fix (or enhancement) to the existing writeback option?

I presume yes (you are fs guy..), but wonder what that reason is.

	-Mike

