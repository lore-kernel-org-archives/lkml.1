Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbXD0Up0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbXD0Up0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbXD0Up0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:45:26 -0400
Received: from smtpauth01.prod.mesa1.secureserver.net ([64.202.165.181]:59328
	"HELO smtpauth01.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757225AbXD0UpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:45:25 -0400
Message-ID: <463260E3.8030209@seclark.us>
Date: Fri, 27 Apr 2007 16:45:23 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
References: <1177660767.6567.41.camel@Homer.simpson.net> <20070427013350.d0d7ac38.akpm@linux-foundation.org> <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com> <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org> <20070427193130.GD5967@schatzie.adilger.int> <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

>On Fri, 27 Apr 2007, Andreas Dilger wrote:
>  
>
>>It's true that this is a "feature" of ext3 with data=ordered (the default),
>>but I suspect the same thing is now true in reiserfs too.
>>    
>>
>
>Oh, well.. Journalling sucks.
>
>I was actually _really_ hoping that somebody would come along and tell 
>everybody that this whole journal-logging is stupid, and that it's just 
>better to not ever re-write blocks on disk, but instead write to new 
>blocks with version numbers (and not re-use old blocks until new versions 
>are stable on disk).
>
>  
>
That sort of sounds like something NCR used to do in the mainframe days 
files had
generation numbers, and multiple generations of the files were kept 
around with the
OS automatically removing the older ones.

>There was even somebody who did something like that for a PhD thesis, I 
>forget the details (and it apparently died when the thesis was presumably 
>accepted ;).
>
>			Linus
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>  
>


-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



