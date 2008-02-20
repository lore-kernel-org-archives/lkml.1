Return-Path: <linux-kernel-owner+w=401wt.eu-S1763457AbYBTCJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763457AbYBTCJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 21:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbYBTCJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 21:09:35 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:41301 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081AbYBTCJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 21:09:35 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Valdis.Kletnieks@vt.edu
Cc: Gunter Ohrner <G.Ohrner@post.rwth-aachen.de>, linux-kernel@vger.kernel.org
Subject: Re: vfat32 Free Cluster Count Update
References: <fp77bc$akv$1@ger.gmane.org> <877ih1w8hb.fsf@duaron.myhome.or.jp>
	<27400.1203467589@turing-police.cc.vt.edu>
Date: Wed, 20 Feb 2008 11:09:28 +0900
In-Reply-To: <27400.1203467589@turing-police.cc.vt.edu> (Valdis Kletnieks's
	message of "Tue, 19 Feb 2008 19:33:09 -0500")
Message-ID: <87fxvotm3r.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu writes:

> (Or is 'df' simply a known way to force execution of a code path that ends up
> fixing the counts as a side-effect?)

Yes. df calls statfs(2), and FAT counts free clusters for ->f_ffree for
it. Then, the free clusters count is fixed as a side-effect.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
