Return-Path: <linux-kernel-owner+w=401wt.eu-S932808AbXCFTJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbXCFTJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932865AbXCFTJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:09:45 -0500
Received: from smtp006.mail.ukl.yahoo.com ([217.12.11.95]:36154 "HELO
	smtp006.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932778AbXCFTJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:09:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FVfKPA2iM21b2BviKDfes10BBEvpJIhI0l5+O8G9Dwj1zjhEvJ9z0zyTcdCOcRG4LLhwintmWf2ScAZhvl3HOhzY6rYyosshPyKvvEepu94SPMzDNV5ssumvxSA6hPohP1IIhELRsHM+NfGAmRCbAx0glTdKLw+BfeIcjxwYRtM=  ;
X-YMail-OSG: wKziGlwVM1lAip0InQwPWMy2vFCJMVQibDBBgzN2YerM9_DZM2RyDxp9OpqjoT68NMWOR..h8NE5UZ6ZHgUCYe3wgg5rbEZDmp57oxzWe4gwdTI4k0Ct9LtDl2nziVEdFCnS1Vlh1fXG
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 4/5] UML - driver formatting fixes
Date: Tue, 6 Mar 2007 20:07:16 +0100
User-Agent: KMail/1.9.5
Cc: Jeff Dike <jdike@addtoit.com>, akpm@osdl.org, linux-kernel@vger.kernel.org
References: <200703061832.l26IWBKi006564@ccure.user-mode-linux.org>
In-Reply-To: <200703061832.l26IWBKi006564@ccure.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703062007.16943.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2007 19:32, Jeff Dike wrote:
> Fix a bunch of formatting violations in the drivers:
> 	return(n) -> return n
> 	whitespace fixes
> 	emacs formatting comment removal
> 	breaking if(foo) return(n) into two lines
>
> There are also a couple of errno use bugs:
> 	using errno in a printk when the failure put errno into a local variable
> 	saving errno after a printk, which can change it
>
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>

> Index: test/arch/um/drivers/chan_user.c
> ===================================================================
> --- test.orig/arch/um/drivers/chan_user.c	2007-03-06 12:09:47.000000000
> -0500 +++ test/arch/um/drivers/chan_user.c	2007-03-06 12:10:12.000000000
> -0500 @@ -158,7 +158,7 @@ static int winch_tramp(int fd, struct tt
>  	 */
>  	err = run_helper_thread(winch_thread, &data, CLONE_FILES, &stack, 0);
>  	if(err < 0){
> -		printk("fork of winch_thread failed - errno = %d\n", errno);
> +		printk("fork of winch_thread failed - errno = %d\n", err);
>  		goto out_close;
>  	}

The second line should better say -err instead of err.
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
