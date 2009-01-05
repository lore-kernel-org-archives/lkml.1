Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZAECzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZAECzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZAECz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:55:27 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:52447
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZAECz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:55:26 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Pavel Machek <pavel@suse.cz>
Subject: Re: document ext3 requirements
Date: Sun, 4 Jan 2009 20:55:13 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Martin =?utf-8?q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       Duane Griffin <duaneg@dghda.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <20090103123813.GA1512@ucw.cz> <495FEE66.9080903@ribosome.natur.cuni.cz> <20090104001859.GH1666@elf.ucw.cz>
In-Reply-To: <20090104001859.GH1666@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901042055.14456.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 18:19:00 Pavel Machek wrote:
> No, you can't mount unclean ext3 as an ext2; patch to do that would be
> possible but...

tune2fs -O ^has_journal /dev/blah
fsck.ext2 -f /dev/blah

Rob
