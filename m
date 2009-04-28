Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbZD1Szk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbZD1Szk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZD1Sza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:55:30 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:56274 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZD1Sz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:55:29 -0400
Subject: Re: [PATCH RFC] ext3 data=guarded v5
From: Chris Mason <chris.mason@oracle.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
In-Reply-To: <1240943582.5611.15.camel@marge.simson.net>
References: <1240941840.15136.44.camel@think.oraclecorp.com>
	 <1240943582.5611.15.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 14:54:14 -0400
Message-Id: <1240944854.15136.46.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49F750DE.002F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 20:33 +0200, Mike Galbraith wrote:
> On Tue, 2009-04-28 at 14:04 -0400, Chris Mason wrote:
> 
> > This patch adds the delayed i_size update to ext3, along with a new
> > mount option (data=guarded) to enable it.
> 
> Is there a good reason to require a new mount option for this vs just
> calling it a fix (or enhancement) to the existing writeback option?
> 
> I presume yes (you are fs guy..), but wonder what that reason is.

It is mostly cutting down on the risk of the patch.  The patch tries to
isolate its changes to just data=guarded mode, so you can go back to the
old and crusty modes if things go badly.

-chris


