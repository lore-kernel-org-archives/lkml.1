Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbYADMfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbYADMfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 07:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYADMfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 07:35:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33100 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYADMfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 07:35:33 -0500
Date: Fri, 4 Jan 2008 12:35:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Dave Young <hidave.darkstar@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
Message-ID: <20080104123529.GA27894@ZenIV.linux.org.uk>
References: <20080104112642.GY27894@ZenIV.linux.org.uk> <477CE1E0.4010504@gmail.com> <Pine.LNX.4.64.0801031550160.2076@sbz-30.cs.Helsinki.FI> <477CEE1C.7020005@gmail.com> <20080104104755.GX27894@ZenIV.linux.org.uk> <20080104111357.GA3429@darkstar.te-china.tietoenator.com> <22924.1199449441@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22924.1199449441@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 12:24:01PM +0000, David Howells wrote:
> Add some more fixes to ISOFS error handling on top of Al Viro's patch:
> 
>  (1) Use IS_ERR() rather than ERR_PTR() to test for errors.

*blush*

My apologies, should've had coffee before posting.  FWIW, this patch
pile is getting ridiculous - it's what, original + 2 fixes in -mm +
mine + this one?  Could you post the updated patch with all fixes
and fixes to fixes folded into it?
