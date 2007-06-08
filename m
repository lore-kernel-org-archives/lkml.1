Return-Path: <linux-kernel-owner+w=401wt.eu-S933022AbXFHOmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbXFHOmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbXFHOm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:42:26 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57195 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753638AbXFHOmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:42:25 -0400
Date: Fri, 8 Jun 2007 16:42:31 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jcm@jonmasters.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <20070608144230.GA5500@stusta.de>
References: <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com> <Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr> <20070607193413.GR5500@stusta.de> <20070607232248.332edee8@the-village.bc.nu> <20070607232152.GU5500@stusta.de> <20070608004117.57868755@the-village.bc.nu> <20070608000455.GW5500@stusta.de> <20070608115219.694c642d@the-village.bc.nu> <20070608123942.GZ5500@stusta.de> <9a8748490706080734h6ce5959fq6e7cb802d9a555cc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a8748490706080734h6ce5959fq6e7cb802d9a555cc@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 04:34:01PM +0200, Jesper Juhl wrote:
> On 08/06/07, Adrian Bunk <bunk@stusta.de> wrote:
> [snip]
>>
>> It's not only about MODULE_AUTHOR, if you consider it rude to limit
>> people's names to ASCII, then don't forget that we have printk's like
>>     Linux agpgart interface v0.102 (c) Dave Jones
>>
>> What happens if the maintainer changes and it's now
>>      Linux agpgart interface v0.103 (c) Dave Ønes
>>
>> Does the console handle it correctly during boot?
>> Can all tools that process the syslog cope with it?
>>
>> Perhaps the answer is in both cases "yes", but it's a completely
>> untested area.
>>
>> We really must have all bugs shaken out and all users using fixed tools
>> _before_ we can start outputting UTF-8 - limiting people's names to
>> ASCII in not ideal, but IMHO causing breakages for users is a much
>> bigger problem.
>
> I haven't looked at it in depth yet, but it would seem we already have
> a few files that need to be looked at with this in mind.  Looks like
> it's not exactely a new problem (although all the following could be
> in comments of course)...
>...

They should all be in comments, and all UTF-8 I've ever seen in such 
files was only in comments (mostly author names). So yes, adding UTF-8 
to program code will result in new problems.

If you find any source file that contains UTF-8 outside of comments 
please complain loudly.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

