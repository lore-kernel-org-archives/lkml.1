Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbZKZSi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbZKZSi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 13:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbZKZSiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 13:38:25 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:46964 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbZKZSiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 13:38:25 -0500
MIME-Version: 1.0
In-Reply-To: <4B0EB4B6.5000702@free.fr>
References: <cover.1259248846.git.kirill@shutemov.name>
	 <4B0EB4B6.5000702@free.fr>
Date: Thu, 26 Nov 2009 20:38:27 +0200
Message-ID: <cc557aab0911261038y63ee617oad5198d04cc38aca@mail.gmail.com>
Subject: Re: [PATCH RFC v0 0/3] cgroup notifications API and memory thresholds
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 7:02 PM, Daniel Lezcano <daniel.lezcano@free.fr> wrote:
> Kirill A. Shutemov wrote:
>>
>> It's my first attempt to implement cgroup notifications API and memory
>> thresholds on top of it. The idea of API was proposed by Paul Menage.
>>
>> It lacks some important features and need more testing, but I want publish
>> it as soon as possible to get feedback from community.
>>
>> TODO:
>>  - memory thresholds on root cgroup;
>>  - memsw support;
>>  - documentation.
>>
>
> Maybe it would be interesting to do that for the /cgroup/<name>/tasks by
> sending in the event the number of tasks in the cgroup when it changes, so
> it more easy to detect 0 process event and then remove the cgroup directory,
> no ?

I'll do it later.
