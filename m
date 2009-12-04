Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbZLDQVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbZLDQVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932158AbZLDQVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:21:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127AbZLDQVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:21:42 -0500
Message-ID: <4B19370E.5030006@redhat.com>
Date: Fri, 04 Dec 2009 11:21:34 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Chris Wright <chrisw@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
References: <20091202125501.GD28697@random.random> <20091203134610.586E.A69D9226@jp.fujitsu.com> <20091204135938.5886.A69D9226@jp.fujitsu.com> <20091204144540.GI28697@random.random>
In-Reply-To: <20091204144540.GI28697@random.random>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 09:45 AM, Andrea Arcangeli wrote:

> I think it's fishy to ignore the page_referenced retval and I don't
> like the wipe_page_referenced concept. page_referenced should only be
> called when we're in presence of VM pressure that requires
> unmapping. And we should always re-add the page to active list head,
> if it was found referenced as retval of page_referenced.

You are wrong here, for scalability reasons I explained
to you half a dozen times before :)

I agree with the rest of your email, though.

-- 
All rights reversed.
