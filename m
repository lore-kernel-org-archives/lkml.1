Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZJ1XUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZJ1XUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 19:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbZJ1XUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 19:20:40 -0400
Received: from are.twiddle.net ([75.149.56.221]:43155 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922AbZJ1XUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 19:20:40 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Oct 2009 19:20:40 EDT
Message-ID: <4AE8D005.1030302@twiddle.net>
Date: Wed, 28 Oct 2009 16:13:09 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Michael Cree <mcree@orcon.net.nz>
CC: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
       ink@jurassic.park.msu.ru, David Howells <dhowells@redhat.com>
Subject: Re: Alpha: suspicious compiler warning in entry.S
References: <4AE7ECC2.8050202@orcon.net.nz>
In-Reply-To: <4AE7ECC2.8050202@orcon.net.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2009 12:03 AM, Michael Cree wrote:
> I am wondering whether it might be better
> to rearrange the bits in the thread information flags so that
> _TIF_WORK_MASK
> has a value less than 255 and the single instruction to perform an and
> operation can be maintained.

It would be better to rearrange TIF_NODIFY_RESUME down to 3.

In fact, you might as well rearrange the ones currently occupying
3-7 up to 8 and leave a hole for _TIF_WORK_MASK expansion, and
add a nice comment there at the same time.


r~
