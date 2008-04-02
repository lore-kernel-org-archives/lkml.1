Return-Path: <linux-kernel-owner+w=401wt.eu-S1759821AbYDBA3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbYDBA3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 20:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757132AbYDBA26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 20:28:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:14277 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016AbYDBA25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 20:28:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=mH27AVda3mwpUXwMblvRhUcmUT6POdq57SjnVEcbEqTzJFLp8P7yYbbHtgRzpkbueJvERgrhhp4s+Xo3zBRa+5NYp2ahOsY6x/+OB7aKyesvvV7y5WK+kNWcAvnoylKyyR0ZVsZaXhf7+aJis2G7fDftjaW+qnGwGWBNxUT7IfQ=
Message-ID: <47F2D343.3060009@gmail.com>
Date: Wed, 02 Apr 2008 04:28:51 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix kernel thread names that might offend users.
References: <87r6dps3db.fsf@saeurebad.de>
In-Reply-To: <87r6dps3db.fsf@saeurebad.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> More and more GNOME users (especially Ubuntu) get confused by their
> process list showing several process names that seem to indicate
> KDE-related services.
> 
> To settle things down a bit on the bugtrackers, this patch renames all
> offending kernel threads into something that goes better with
> GNOME-based systems.
> 
> Since KDE is essentially dead, the thread-names are not made
> compile-time configurable but rather just renamed completely here to
> fit modern distributions. 
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> ---
> 
> Please note that these hard-coded names are going to be removed soon
> completely in another patch series that makes kernel thread names more
> `themable' in the sense that users may supply a format string in
> /proc/sys/kernel/kthread_fmt which allows having customizable names
> like "-=[acpid]=-" or similar.
> 
> Also, please let me know if I forgot something. 

Did you forget to send this patch yesterday in which case this would have
been more suitable for April 1st?

Dmitri
