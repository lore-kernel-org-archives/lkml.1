Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbZKZRCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbZKZRCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760859AbZKZRCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:02:44 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:55471 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760842AbZKZRCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:02:42 -0500
Message-ID: <4B0EB4B6.5000702@free.fr>
Date: Thu, 26 Nov 2009 18:02:46 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH RFC v0 0/3] cgroup notifications API and memory thresholds
References: <cover.1259248846.git.kirill@shutemov.name>
In-Reply-To: <cover.1259248846.git.kirill@shutemov.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> It's my first attempt to implement cgroup notifications API and memory
> thresholds on top of it. The idea of API was proposed by Paul Menage.
>
> It lacks some important features and need more testing, but I want publish
> it as soon as possible to get feedback from community.
>
> TODO:
>  - memory thresholds on root cgroup;
>  - memsw support;
>  - documentation.
>   
Maybe it would be interesting to do that for the /cgroup/<name>/tasks by 
sending in the event the number of tasks in the cgroup when it changes, 
so it more easy to detect 0 process event and then remove the cgroup 
directory, no ?
