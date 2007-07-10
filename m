Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbXGJOQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbXGJOQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 10:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbXGJOQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 10:16:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:32985 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbXGJOQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 10:16:46 -0400
In-Reply-To: <11840373002601-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com> <11840360383913-git-send-email-hpa@zytor.com> <11840361432207-git-send-email-hpa@zytor.com> <11840362483663-git-send-email-hpa@zytor.com> <11840363531039-git-send-email-hpa@zytor.com> <11840364593068-git-send-email-hpa@zytor.com> <1184036564610-git-send-email-hpa@zytor.com> <11840366692770-git-send-email-hpa@zytor.com> <11840367741994-git-send-email-hpa@zytor.com> <11840368791603-git-send-email-hpa@zytor.com> <11840369841576-git-send-email-hpa@zytor.com> <11840370903975-git-send-email-hpa@zytor.com> <11840371953778-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [x86 setup 13/33] Header file to produce 16-bit code with gcc
Date: Tue, 10 Jul 2007 16:16:29 +0200
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> gcc for i386 can be used with the assembly prefix ".code16gcc" to  
> generate
> 16-bit (real-mode) code.  This header file provides the assembly  
> prefix.

This only works correctly with newer GCCs if you pass the
-fno-toplevel-reorder option (and it only works on older
GCC versions by accident).  This option however disables
certain optimisations; but perhaps that doesn't matter all
that much here.


Segher

