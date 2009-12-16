Return-Path: <linux-kernel-owner+w=401wt.eu-S1762413AbZLPRMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762413AbZLPRMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762255AbZLPRMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:12:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbZLPRML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:12:11 -0500
Message-ID: <4B29148A.70805@zytor.com>
Date: Wed, 16 Dec 2009 09:10:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: David Teigland <teigland@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-kernel@vger.kernel.org, rubini@gnudd.com, gregkh@suse.de
Subject: Re: [PATCH 3/3] misc: use a proper range for minor number dynamic
 allocation
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com> <1257813017-28598-2-git-send-email-cascardo@holoscopio.com> <1257813017-28598-3-git-send-email-cascardo@holoscopio.com> <4AF8B4FF.9050405@zytor.com> <20091111153632.944a255c.akpm@linux-foundation.org> <20091215143446.8b6a7e57.akpm@linux-foundation.org> <20091215233738.26188500@lxorguk.ukuu.org.uk> <20091216180155.GA23117@redhat.com>
In-Reply-To: <20091216180155.GA23117@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 10:01 AM, David Teigland wrote:
> 
> I explained here http://lkml.org/lkml/2009/11/9/379 that the dlm does not
> use as many misc devices as has been implied.  It starts with 3, and adds
> one for each *userspace* lockspace.  There are very few applications (I
> know of 3) that create userspace lockspaces, and they each create about
> one each.
> 
> That said, I still intend to rework the dlm to use a single device for all
> lockspaces.
> 

Still seems to make more sense to simply move it to a major and/or a
dynamic allocation.  misc devices were always meant to be *one of a
kind* devices, which simply didn't need anything but a single allocation.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

