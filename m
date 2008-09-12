Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbYILVVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbYILVVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbYILVVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:21:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58635 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbYILVVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:21:46 -0400
Message-ID: <48CADD30.1040108@zytor.com>
Date: Fri, 12 Sep 2008 14:20:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux@sandersweb.net
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: nops in virtual pc x86
References: <200809121711.48558.linux@sandersweb.net>
In-Reply-To: <200809121711.48558.linux@sandersweb.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Sanders wrote:
> 
> Could it perhaps depend on the context the nops appear in?
> 

Almost certainly.  Most likely it's broken in the Virtual PC 
interpreter, but anything that is executed natively works.

	-hpa
