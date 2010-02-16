Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab0BPMcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 07:32:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49786 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751946Ab0BPMcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 07:32:14 -0500
Date: Tue, 16 Feb 2010 12:31:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nameer Yarkon <nameer.yarkon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Reading /dev/mem by dd
Message-ID: <20100216123141.6c601dfd@lxorguk.ukuu.org.uk>
In-Reply-To: <bec9a5871002160035v63cce8ck9ecb9252b2f162a6@mail.gmail.com>
References: <bec9a5871002160035v63cce8ck9ecb9252b2f162a6@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> how does X11 get now direct access to the physical memory (instead of
> /dev/mem) ?

Via frame buffer devices.

If you think about things like hot-plug it's rather hard to do frame
buffer access any other way. The rules on memory types and aliasing also
make it nearly impossible to do properly with /dev/mem on a modern CPU.

Alan
