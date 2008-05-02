Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbYEBWgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbYEBWgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756683AbYEBWfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:35:52 -0400
Received: from lazybastard.de ([212.112.238.170]:50396 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbYEBWfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:35:52 -0400
Date: Sat, 3 May 2008 00:35:39 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] find dynamic stack allocations in checkstack.pl
Message-ID: <20080502223539.GH24080@logfs.org>
References: <481B4EC5.6060507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <481B4EC5.6060507@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 12:26:29 -0500, Eric Sandeen wrote:
> 
> @@ -142,6 +148,22 @@ while (my $line = <STDIN>) {
>  		next if ($size < 100);
>  		push @stack, "$intro$size\n";
>  	}
> +	elsif (defined $dre && $line =~ m/$dre/) {

These two could join a line.  Otherwise an excellent addition.

Reviewed-By: Joern Engel <joern@logfs.org>

Jörn

-- 
"Translations are and will always be problematic. They inflict violence
upon two languages." (translation from German)
