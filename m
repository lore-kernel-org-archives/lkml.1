Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbZHFT2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbZHFT2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756512AbZHFT2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:28:07 -0400
Received: from in.cluded.net ([195.159.98.120]:33596 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082AbZHFT2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:28:06 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2009 15:28:06 EDT
Message-ID: <4A7B2C3A.9090709@uw.no>
Date: Thu, 06 Aug 2009 19:17:14 +0000
From: "Daniel K." <dk@uw.no>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Luis R. Rodriguez" <lrodriguez@Atheros.com>, joe@perches.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mcgrof@gmail.com
Subject: Re: [PATCH 3/3] checkincludes.pl: add option to remove duplicates
 in place
References: <1249519872-23958-1-git-send-email-lrodriguez@atheros.com>	<1249519872-23958-4-git-send-email-lrodriguez@atheros.com> <20090805185945.1ece6088.akpm@linux-foundation.org>
In-Reply-To: <20090805185945.1ece6088.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 5 Aug 2009 17:51:12 -0700 "Luis R. Rodriguez" <lrodriguez@Atheros.com> wrote:
>> -	print "Usage: checkincludes.pl <file list>\n";
>> +	print "Usage: checkincludes.pl [-r]\n";
>> +	print "By default we just warn of duplicates\n";
>> +	print "To remove files in place use -r\n";
> 
> I'm not sure I like the wording here - I don't _want_ my files removed!
> 
> This?
> 
> --- a/scripts/checkincludes.pl~checkincludespl-add-option-to-remove-duplicates-in-place-fix
> +++ a/scripts/checkincludes.pl
> @@ -7,7 +7,7 @@
>  sub usage {
>  	print "Usage: checkincludes.pl [-r]\n";
>  	print "By default we just warn of duplicates\n";
> -	print "To remove files in place use -r\n";
> +	print "To remove duplicated includes in place use -r\n";
>  	exit 1;
>  }
>  

And perhaps the '<file list>' should be kept as well, for documentation?

--- a/scripts/checkincludes.pl
+++ a/scripts/checkincludes.pl
@@ -5,7 +5,7 @@
 # Copyright abandoned, 2009, Luis R. Rodriguez <mcgrof@gmail.com>
 
 sub usage {
-	print "Usage: checkincludes.pl [-r]\n";
+	print "Usage: checkincludes.pl [-r] <file list>\n";
 	print "By default we just warn of duplicates\n";
 	print "To remove duplicated includes in place use -r\n";
 	exit 1;


Daniel K.
