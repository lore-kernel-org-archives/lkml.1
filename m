Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbXJ1PyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbXJ1PyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 11:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbXJ1Px4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 11:53:56 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49092 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbXJ1Pxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 11:53:55 -0400
Date: Sun, 28 Oct 2007 09:53:54 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Adrian Bunk <bunk@kernel.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] scsi/seagate.c: remove dead code
Message-ID: <20071028155354.GJ27248@parisc-linux.org>
References: <20071028155142.GB7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028155142.GB7227@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 04:51:42PM +0100, Adrian Bunk wrote:
> This patch removes obviously dead code.
>  				case LINKED_WRONG:
>  					WRITE_DATA (ABORT);
>  					linked_connected = 0;
>  					reselect = CAN_RECONNECT;
>  					goto connect_loop;
> -					DPRINTK (PHASE_MSGOUT | DEBUG_LINKED, "scsi%d : sent ABORT message to cancel incorrect I_T_L nexus.\n", hostno);
>  #endif					/* LINKED */
> -					DPRINTK (DEBUG_LINKED, "correct\n");
>  				default:

Surely the 'goto' should just be moved two lines down?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
