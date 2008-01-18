Return-Path: <linux-kernel-owner+w=401wt.eu-S1761595AbYARNKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595AbYARNKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760935AbYARNKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:10:41 -0500
Received: from sa8.bezeqint.net ([192.115.104.22]:44912 "EHLO sa8.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760752AbYARNKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:10:39 -0500
Message-ID: <4790A544.8090202@panasas.com>
Date: Fri, 18 Jan 2008 15:10:28 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.13
References: <1200587031.0@pinky> <20080117111923.c2418586.akpm@linux-foundation.org> <20080118113717.GE18948@shadowen.org>
In-Reply-To: <20080118113717.GE18948@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan. 18, 2008, 13:37 +0200, Andy Whitcroft <apw@shadowen.org> wrote:
> On Thu, Jan 17, 2008 at 11:19:23AM -0800, Andrew Morton wrote:
>> On Thu, 17 Jan 2008 16:23:51 -0000 Andy Whitcroft <apw@shadowen.org> wrote:
>>
>>> This version brings a large number of fixes which have built up over
>>> the Christmas period.  Mostly these are fixes for false positives, both
>>> through improvments to unary checks and possible type detection.  It
>>> also brings new checks for while location and CVS keywords.
>> heh.  Doctor, heal thyself.
> 
> Heh, yeah I was feeling pressure to push out the update and forgot to
> check it.  Spanner.
> 
> I have fixed the three lines which have random tabs on them.  Its
> something I do in vi which is adding them, one day I will figure out
> what the heck it is I do.

autoindent set by any chance?
try :set noai
If you you like it better this way you can configure it in your vi{,m}rc

Benny

> 
> -apw
> 
> ---
> clean up some space violations in checkpatch.pl
> 
> Seems that something I do in vi leaves lines with multiple tabs on
> them lying about.  Clean these up before edit things more.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> ---
>  checkpatch.pl |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/checkpatch.pl b/checkpatch.pl
> index 07ba401..a2b4c41 100755
> --- a/checkpatch.pl
> +++ b/checkpatch.pl
> @@ -341,7 +341,7 @@ sub sanitise_line {
>  		my $clean = 'X' x length($1);
>  		$res =~ s@(#\s*(?:error|warning)\s+).*@$1$clean@;
>  	}
> -		
> +
>  	return $res;
>  }
>  
> @@ -947,7 +947,7 @@ sub process {
>  		if ($realcnt) {
>  			# Ignore goto labels.
>  			if ($line =~ /$Ident:\*$/) {
> -				
> +
>  			# Ignore functions being called
>  			} elsif ($line =~ /^.\s*$Ident\s*\(/) {
>  
> @@ -1190,7 +1190,7 @@ sub process {
>  
>  			# Ignore those directives where spaces _are_ permitted.
>  			if ($name =~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case)$/) {
> -			
> +
>  			# cpp #define statements have non-optional spaces, ie
>  			# if there is a space between the name and the open
>  			# parenthesis it is simply not a parameter group.

