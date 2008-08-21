Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbYHUEvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbYHUEvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 00:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYHUEv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 00:51:28 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:62141 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbYHUEv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 00:51:27 -0400
Message-Id: <200808210457.AA00214@capsicum.lab.ntt.co.jp>
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Date: Thu, 21 Aug 2008 13:57:23 +0900
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
In-Reply-To: <87iqtwyq55.fsf@basil.nowhere.org>
References: <87iqtwyq55.fsf@basil.nowhere.org>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 11:47:18 +0200 Andi Kleen wrote:
>> It has many TODO items:
>
>How stable is the on-disk format?

It's almost stable.
Hopefully I don't want to make any major change on the on-disk
format which affects the compatibility.

Some unsupported features like atime, EA, and ACLs should be
carefully confirmed before merging to the mainline though
I believe they don't lead to the major change.

>If the file system makes mainline
>your user base would likely increase significantly. Users then tend
>to have a reasonable exception that they can still mount old file systems
>later on newer kernels (although not necessarily the other way round)

Yes I know.  Thank you for the important advice.
