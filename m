Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbZF3Olc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbZF3Olc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZF3OlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:41:22 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:60137 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbZF3OlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:41:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OTg5ViMGlyM9jh7xgEoFVkXUCJjbvCZFn+n1t81IgB6qTRozC8EDNyHYtyu61sVGP/
         Ss6ap2QSPHnIfaI/hjaEcLae6C10NXGOSSZLnihF1KtdcmNAHuOkZhKbP2zA5+cPDhAx
         ql0TjpHiRbfkWqSMQ2o7mwDjtHuDo6k6fFwTE=
Subject: [BUG] MIPS: Hibernation in the latest linux-mips:master branch not
 work
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org
Cc: Pavel Machek <pavel@ucw.cz>, Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Tue, 30 Jun 2009 22:41:08 +0800
Message-Id: <1246372868.19049.17.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just updated my git repository to the master branch of the latest
linux-mips git repository, and tested the STD/Hibernation support on
fuloong2e and yeeloong2f, it failed:

when using the no_console_suspend kernel command line to debug, it
stopped on:

PM: Shringking memory... done (1000 pages freed)
PM: Freed 160000 kbytes in 1.68 seconds (95.23 MB/s)
PM: Creating hibernation image:
PM: Need to copy 5053 pages
PM: Hibernation image created (4195 pages copied)

and then, the number indicator light of keyboard works well, but can not
type anything. 

anybody have tested it on another platform? does it work?

Regards,
Wu Zhangjin

