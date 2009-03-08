Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZCHSRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZCHSRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 14:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbZCHSR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 14:17:29 -0400
Received: from 1wt.eu ([62.212.114.60]:1178 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbZCHSR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 14:17:29 -0400
Date: Sun, 8 Mar 2009 19:10:56 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Keymap 0: Permission denied
Message-ID: <20090308181056.GM26043@1wt.eu>
References: <1236533626.1479.8.camel@rh9.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236533626.1479.8.camel@rh9.satnam>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Mar 08, 2009 at 11:03:46PM +0530, Jaswinder Singh Rajput wrote:
> Hello Willy,
> 
> On Red Hat 9 With latest 2.4-git kernel, when I log in as a regular user
> on a TTY, I get the following error:
> 
> Keymap 0: Permission denied
> Keymap 1: Permission denied
> Keymap 2: Permission denied
> KDSKBENT: Operation not permitted
> loadkeys: could not deallocate keymap 3
> 
> How to fix this error.

No idea yet. Could you please try "loadkey us" for instance, to ensure
it is the program which fails ? If so, please send me the output of
"strace loadkeys us".

Regards,
Willy

