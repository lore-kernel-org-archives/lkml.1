Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbYEDXa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbYEDXa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 19:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYEDXar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 19:30:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55930 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbYEDXaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 19:30:46 -0400
Message-ID: <481E4655.7040000@zytor.com>
Date: Sun, 04 May 2008 16:27:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: sam@ravnborg.org, lkml List <linux-kernel@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>
Subject: Re: How to link a .o with all modules
References: <6C8AB345-2DA0-460D-B7C8-262463247DDE@kernel.crashing.org>
In-Reply-To: <6C8AB345-2DA0-460D-B7C8-262463247DDE@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> Sam,
> 
> We have a case in powerpc in which we want to link some library routines 
> with all module objects.  The routines are intended for handling 
> out-of-line function call register save/restore so having them as 
> EXPORT_SYMBOL() is counter productive (we do also need to link the same 
> "library" code into the kernel).
> 

Why is having them as an EXPORT_SYMBOL() counterproductive?  It sounds 
like *exactly* what you need -- and then having the kernel provide the 
same code to modules, instead of replication...?

	-hpa
