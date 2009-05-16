Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZEPRij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZEPRij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 13:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZEPRia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 13:38:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44445 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbZEPRi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 13:38:29 -0400
Message-ID: <4A0EFA08.4060106@redhat.com>
Date: Sat, 16 May 2009 13:38:16 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Satish Eerpini <eerpini@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, fengguang.wu@intel.com
Subject: Re: unresponsiveness on linux desktop during file copy
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com> 	<2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com> 	<alpine.DEB.1.10.0905151533070.13433@qirst.com> <2c0942db0905160903i5517d3d6l50fc7457a2629694@mail.gmail.com>
In-Reply-To: <2c0942db0905160903i5517d3d6l50fc7457a2629694@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On Fri, May 15, 2009 at 12:33 PM, Christoph Lameter
> <cl@linux-foundation.org> wrote:
>> On Fri, 15 May 2009, Ray Lee wrote:
>>
>>> Which kernel version? If it's something recent, your programs may be
>>> getting swapped out due to a flaw in the latest kernels, where it
>>> accidentally prefers caching file data over mapped pages. If that's
>>> the case, Rik (cc:d) is working on patches to address the issue, and
>>> may appreciate another tester.
>> Please keep me in the loop. I'd be interested if those patches work and
>> what effect they have.
> 
> Whoops, looks like Wu Fengguang (cc:d), not Rik, has been working on
> those patches. See the messages starting with "[PATCH 0/3] make mapped
> executable pages the first class citizen" [
> http://lkml.org/lkml/2009/5/16/23 ]

We both have.  Wu's patches build on a patch of mine, which
Andrew has already merged into -mm.

http://lkml.org/lkml/2009/4/29/489

-- 
All rights reversed.
