Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbYHGRqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbYHGRqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbYHGRqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:46:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbYHGRqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:46:04 -0400
Message-ID: <489B34BA.4060300@linux-foundation.org>
Date: Thu, 07 Aug 2008 12:45:30 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andi Kleen <andi@firstfloor.org>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <200808060133.10457.nickpiggin@yahoo.com.au> <87r6926dsr.fsf@basil.nowhere.org> <200808061550.22996.nickpiggin@yahoo.com.au>
In-Reply-To: <200808061550.22996.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

> OK thanks for the info. I don't actually know debugger code as I
> said, so I wasn't against merging mdb if it offers things that
> kgdb fundamentally cannot.
> 
> If so, then ensuring clean interfaces indeed would seem like a
> good first step to getting it merged.

The competing implementation is kdb not kgdb. kgdb is just a stub for remote
debugging using gdb. kdb is an in-kernel debugger like the one proposed here.
