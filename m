Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbYE1Qkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbYE1Qkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYE1Qk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:40:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbYE1Qk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:40:28 -0400
Message-ID: <483D8AE0.8090606@redhat.com>
Date: Wed, 28 May 2008 12:40:00 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Jens_B=E4ckman?= <jens.backman@gmail.com>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
In-Reply-To: <95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Bäckman wrote:
> On Wed, May 28, 2008 at 10:53 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> Results:
>>
>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt
> 
> Either the RAID 1 read speed must be wrong, or something is odd in the
> Linux implementation. There's six drives that can be used for reading
> at the same time, as they contain the very same data. 63MB/s
> sequential looks like what you would get from a single drive.

The test is a single thread reading one block at a time, so this is not 
surprising.  If you get this doing multi-megabyte readahead, or with 
several threads, something is very wrong.

-- Chris
