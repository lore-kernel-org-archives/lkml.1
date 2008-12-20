Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbYLTEhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbYLTEhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 23:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYLTEhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 23:37:31 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:14017 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYLTEhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 23:37:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=LcD25RCzs5d57yXOMvTCUQaumfUgLW0fr1gAxhds4qMzcqr+7OCpXjxyei3ShT7F6e
         q589jKTSBpkgmhW+rKqwOUJctoNXl/EvayS6IlEEyMcUGKy9AvXPAgSEV9phkUfsgnH8
         nJukA1ng8kh/x5NNXkQZ1Q1rfToVGZZCrUF/s=
Message-ID: <a36005b50812192037g1380a997ycc87f600db18af0c@mail.gmail.com>
Date: Fri, 19 Dec 2008 20:37:29 -0800
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: st_mode bits
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is the future of the bits beyond bit 15 in st_mode?  Currently
only 16 bits are used.  There are old struct stat formats which have
only 16 bit st_mode fields.  Is this the limiting factor?

I ask because I want to use one bit in glibc.  If the future of the
kernel calls for more than 16 bits in st_mode, can we agree on a bit
(perhaps bit 31) to be reserved for userlevel?
