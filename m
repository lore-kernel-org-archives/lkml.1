Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYJYFkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYJYFkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 01:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYJYFkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 01:40:25 -0400
Received: from 1wt.eu ([62.212.114.60]:4921 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbYJYFkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 01:40:24 -0400
Date: Sat, 25 Oct 2008 07:40:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: Joe Damato <ice799@gmail.com>
Cc: linux-x86_64@vger.kernel.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] x86: Cleanup idt, gdt/ldt/tss structs
Message-ID: <20081025054018.GU24654@1wt.eu>
References: <1224904532-9586-1-git-send-email-ice799@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224904532-9586-1-git-send-email-ice799@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 08:15:20PM -0700, Joe Damato wrote:
> Hi -
> 
> This is my first submission to the kernel, so (beware!) please let me know if I can make any improvements on these patches.

It looks like you provide one patch per file. You should group some of them
together so that each patch does a functional change and everything still
builds after incrementally applying that patch. The way you have splitted
them will break builds if someone tries to build after patch 1 for instance.

Willy

