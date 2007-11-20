Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbXKTESm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbXKTESm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 23:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbXKTESf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 23:18:35 -0500
Received: from ro-out-1112.google.com ([72.14.202.181]:36780 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbXKTESe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 23:18:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mCwzZIpsy2y8RAq1aNRw/IozCHjeJvFe3u6j9g6wTBT4pV4/DxqbaNlClTqZRwr/Ks+trFcIT8ue4wvybnQjx4WBtt/AD6ICzlgUzcR4lHqZUU/KelMdnSax6oGPFDUE5cCc3Gcknn6KRG0I7FTcwsLEUjXsT3EBE80TcbLC4x8=
Date: Tue, 20 Nov 2007 12:16:00 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: zhengyi <goodmenkernel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is there any word about this bug in gcc ?
Message-ID: <20071120041600.GC2472@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071120.101342.85695496.goodmenzy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120.101342.85695496.goodmenzy@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 10:13:42AM +0800, zhengyi wrote:
>Is there any relevance to the kernel ?
>
>I found the folowing code here:
>http://linux.solidot.org/article.pl?sid=07/11/19/0512218&from=rss
>
>-------------------------------------------------------------------
>int main( void )
>{
>  int i=2;
>  if( -10*abs (i-1) == 10*abs(i-1) )
>    printf ("OMG,-10==10 in linux!\n");
>  else
>    printf ("nothing special here\n") ;
>
>  return 0 ;
>}

I think no. It is considered a bug in abs(), kernel, of course,
doesn't use glibc's abs().

Regards.

