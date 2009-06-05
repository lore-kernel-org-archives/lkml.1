Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZFEQv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZFEQv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZFEQvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:51:51 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:65186 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZFEQvu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:51:50 -0400
MIME-Version: 1.0
In-Reply-To: <4A294B15.9070209@tuffmail.co.uk>
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com> 
	<4A293084.5010400@tuffmail.co.uk> <4A2937CC.7070503@redhat.com> 
	<4A294B15.9070209@tuffmail.co.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 5 Jun 2009 18:51:31 +0200
Message-ID: <ac3eb2510906050951o200c3aeex56dcb32bf29d0607@mail.gmail.com>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Eric Sandeen <sandeen@redhat.com>, Aioanei Rares <krnl.list@gmail.com>,
       linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 18:43, Alan Jenkins<alan-jenkins@tuffmail.co.uk> wrote:

> If I remove the corrupted file and copy a "known good" copy into it's place,
> then the corruption doesn't happen.  I've verified this a couple of times.
>  The corruption only occurs if the file was created by "locale-gen".

Does it use things like: fallocate()?

Kay
